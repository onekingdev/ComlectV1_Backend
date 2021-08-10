# frozen_string_literal: true

class PdfCompliancePolicyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'tmpdir'

  def env_path(in_path)
    Rails.env.production? || Rails.env.staging? ? in_path : "#{Rails.root}/public#{in_path}"
  end

  def perform(policy_doc_id)
    policy_doc = CompliancePolicyDoc.find(policy_doc_id)
    tgt_compliance_policy = policy_doc.compliance_policy.business.compliance_policies.first
    tgt_compliance_policy.update(pdf: nil)
    doc_path = env_path(policy_doc.doc_url.split('?')[0])
    uploader = PdfUploader.new(:store)

    file = if Rails.env.production? || Rails.env.staging?
      URI.parse(doc_path).open
    else
      File.open(doc_path)
    end
    uploaded_file = uploader.upload(file)
    policy_doc.update(pdf_data: uploaded_file.to_json)
    compliance_policy = policy_doc.compliance_policy
    compliance_policy.set_last_upload_date

    pdf = ApplicationController.new.render_to_string pdf: 'compliance_manual.pdf',
                                                     template: 'business/compliance_policies/header.pdf.erb', encoding: 'UTF-8',
                                                     locals: {
                                                       last_updated: compliance_policy.last_uploaded,
                                                       business: policy_doc.compliance_policy.business
                                                     },
                                                     margin: {
                                                       top: 20,
                                                       bottom: 25,
                                                       left: 15,
                                                       right: 15
                                                     }
    uploader = PdfUploader.new(:store)
    file = Tempfile.new(["compliance_manual_header_#{compliance_policy.id}", '.pdf'])
    file.binmode
    file.write(pdf)
    file.rewind
    merged_pdf = CombinePDF.new
    merged_pdf << CombinePDF.load(file.path)

    compliance_policy.business.sorted_unban_compliance_policies.each do |cpolicy|
      begin
        if cpolicy.compliance_policy_docs.first.present?
          pdf_path = env_path(cpolicy.compliance_policy_docs.first.pdf_url.split('?')[0])
          merged_pdf << if Rails.env.production? || Rails.env.staging?
            CombinePDF.parse(URI.open(pdf_path).read)
          else
            CombinePDF.load(pdf_path)
          end
        end
      rescue StandardError
        if cpolicy.compliance_policy_docs.count > 1
          cpolicy.compliance_policy_docs.first.destroy
          # else
          #   cpolicy.destroy
        end
      end
      cpolicy.calculate_docs
    end
    tmp_pdf_file = Tempfile.new(["compliance_manual-#{compliance_policy.id}", '.pdf'])
    tmp_pdf_path = tmp_pdf_file.path
    merged_pdf.number_pages(number_format: ' %s ', location: :bottom, font_size: 12,
                            margin_from_height: 5, start_at: 1, page_range: (1..-1))
    merged_pdf.save tmp_pdf_path
    tmp_pdf_file.rewind
    uploaded_file = uploader.upload(File.new(tmp_pdf_file))
    tgt_compliance_policy.update(pdf_data: uploaded_file.to_json)
    tmp_pdf_file.unlink
    file.delete
  end
end

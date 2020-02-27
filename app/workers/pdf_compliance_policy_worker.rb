# frozen_string_literal: true

class PdfCompliancePolicyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'tmpdir'

  def env_path(in_path)
    Rails.env.production? || Rails.env.staging? ? in_path : "#{Rails.root}/public#{in_path}"
  end

  # rubocop:disable Metrics/LineLength
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def perform(policy_doc_id)
    policy_doc = CompliancePolicyDoc.find(policy_doc_id)
    tgt_compliance_policy = policy_doc.compliance_policy.business.compliance_policies.first
    tgt_compliance_policy.update(pdf: nil)
    doc_path = env_path(policy_doc.doc_url.split('?')[0])
    tmp_fd = Tempfile.new(['pdf-', '.pdf'])
    uploader = PdfUploader.new(:store)

    if MIME::Types.type_for(doc_path).first.to_s == 'application/pdf'
      file = if Rails.env.production? || Rails.env.staging?
               URI.parse(doc_path).open
             else
               File.open(doc_path)
             end
    else
      Libreconv.convert(doc_path, tmp_fd.path)
      file = File.new(tmp_fd)
    end
    uploaded_file = uploader.upload(file)
    policy_doc.update(pdf_data: uploaded_file.to_json)
    compliance_policy = policy_doc.compliance_policy
    compliance_policy.set_last_upload_date

    pdf = ApplicationController.new.render_to_string pdf: 'compliance_manual.pdf',
                                                     template: 'business/compliance_policies/header.pdf.erb', encoding: 'UTF-8',
                                                     locals: { last_updated: compliance_policy.last_uploaded, business: policy_doc.compliance_policy.business },
                                                     margin: { top:               20,
                                                               bottom:            25,
                                                               left:              15,
                                                               right:             15 }
    uploader = PdfUploader.new(:store)
    file = Tempfile.new(["compliance_manual_header_#{compliance_policy.id}", '.pdf'])
    file.binmode
    file.write(pdf)
    file.rewind
    merged_pdf = CombinePDF.new
    merged_pdf << CombinePDF.load(file.path)

    I18n.translate('compliance_manual_sections').keys.each do |section|
      compliance_policy.business.compliance_policies.where(section: section.to_s).each do |cpolicy|
        begin
          merged_pdf << CombinePDF.load(env_path(cpolicy.compliance_policy_docs.first.pdf_url.split('?')[0]))
        rescue CombinePDF::EncryptionError
          if cpolicy.compliance_policy_docs.count > 1
            cpolicy.compliance_policy_docs.first.destroy
          else
            cpolicy.destroy
          end
        end
      end
    end
    compliance_policy.business.compliance_policies.where.not(title: '').each do |cpolicy|
      begin
        merged_pdf << CombinePDF.load(env_path(cpolicy.compliance_policy_docs.first.pdf_url.split('?')[0]))
      rescue CombinePDF::EncryptionError
        if cpolicy.compliance_policy_docs.count > 1
          cpolicy.compliance_policy_docs.first.destroy
        else
          cpolicy.destroy
        end
      end
    end
    tmp_pdf_file = Tempfile.new(["compliance_manual-#{compliance_policy.id}", '.pdf'])
    tmp_pdf_path = tmp_pdf_file.path
    merged_pdf.save tmp_pdf_path
    tmp_pdf_file.rewind
    uploaded_file = uploader.upload(File.new(tmp_pdf_file))
    tgt_compliance_policy.update(pdf_data: uploaded_file.to_json)
    tmp_pdf_file.unlink
    file.delete
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/LineLength
end

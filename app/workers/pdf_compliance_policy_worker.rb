# frozen_string_literal: true

class PdfCompliancePolicyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'tmpdir'

  def env_path(in_path)
    Rails.env.production? || Rails.env.staging? ? in_path : "#{Rails.root}/public#{in_path}"
  end

  def perform(policy_id)
    cpolicy = CompliancePolicy.find(policy_id)
    not_edited = cpolicy.business.compliance_policies.root_published.select { |n| n.edited_at.nil? }
    not_edited.each { |ne| ne.update_attribute('edited_at', ne.updated_at) }
    combined_policy_db = cpolicy.business.combined_policy.presence ||
                         CombinedPolicy.create(business_id: cpolicy.business.id)
    cpolicy.update(pdf: nil)
    cpconf = cpolicy.business.compliance_policy_configuration

    pdf_header = ApplicationController.new.render_to_string pdf: 'compliance_manual_header.pdf',
                                                            template: 'business/compliance_policies/header.pdf.erb', encoding: 'UTF-8',
                                                            locals: {
                                                              last_updated: cpolicy.business.compliance_policies.root_published.collect(&:edited_at).max.in_time_zone(cpolicy.business.time_zone),
                                                              business: cpolicy.business,
                                                              logo: (env_path(cpconf.logo_url(:original).split('?')[0]) if cpconf.logo.present?),
                                                              cpolicy: cpolicy,
                                                              cpconf: cpconf
                                                            }, margin: { top: 20, bottom: 15, left: 15, right: 15 }

    file_header = Tempfile.new(["compliance_policy_header_#{cpolicy.business.id}", '.pdf'])
    file_header.binmode
    file_header.write(pdf_header)
    file_header.rewind

    toc = []
    current_page = 1
    combined_everything = CombinePDF.new
    combined_everything << CombinePDF.load(file_header.path)
    file_header.delete
    combined_policies = CombinePDF.new
    cpolicy.business.compliance_policies.root_published.each do |published_cpolicy|
      pdf = ApplicationController.new.render_to_string pdf: 'compliance_manual.pdf',
                                                       template: 'business/compliance_policies/cpolicy.pdf.erb', encoding: 'UTF-8',
                                                       locals: { cpolicy: published_cpolicy },
                                                       margin: { top: 20, bottom: 15, left: 15, right: 15 }
      file = Tempfile.new(["cpolicy_#{published_cpolicy.id}", '.pdf'])
      file.binmode
      file.write(pdf)
      file.rewind
      loaded_pdf = CombinePDF.load(file.path)
      loaded_pdf.number_pages(location: [:bottom], font_size: 8, margin_from_side: 0, margin_from_height: 20, start_at: current_page)
      loaded_pdf.save file.path
      uploader = PdfUploader.new(:store)
      uploaded_file = uploader.upload(file)
      page_count = loaded_pdf.pages.count
      combined_policies << loaded_pdf
      published_cpolicy.update(pdf_data: uploaded_file.to_json, page_count: page_count)
      toc.push(name: published_cpolicy.name, page_start: current_page, page_end: current_page + page_count)
      current_page += page_count
      file.delete
    end

    pdf_toc = ApplicationController.new.render_to_string pdf: 'toc.pdf',
                                                         template: 'business/compliance_policies/toc.pdf.erb', encoding: 'UTF-8',
                                                         locals: { toc: toc },
                                                         margin: { top: 20, bottom: 15, left: 15, right: 15 }
    file_toc = Tempfile.new(["cpolicy_toc_#{cpolicy.business.id}", '.pdf'])
    file_toc.binmode
    file_toc.write(pdf_toc)
    file_toc.rewind
    combined_everything << CombinePDF.load(file_toc.path)
    # combined_policies.number_pages(location: [:bottom], font_size: 8, margin_from_side: 0, margin_from_height: 20)
    combined_everything << combined_policies
    tmp_pdf_file = Tempfile.new(["combined_policy_#{combined_policy_db.id}", '.pdf'])
    tmp_pdf_path = tmp_pdf_file.path
    combined_everything.save tmp_pdf_path
    tmp_pdf_file.rewind
    uploader = PdfUploader.new(:store)
    uploaded_file = uploader.upload(File.new(tmp_pdf_file))
    combined_policy_db.update(file_data: uploaded_file.to_json)
    tmp_pdf_file.delete
    file_toc.delete
  end
end

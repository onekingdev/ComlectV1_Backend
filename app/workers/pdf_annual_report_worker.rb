# frozen_string_literal: true

class PdfAnnualReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'tmpdir'

  def env_path(in_path)
    Rails.env.production? || Rails.env.staging? ? in_path : "#{Rails.root}/public#{in_path}"
  end

  def perform(areport_id)
    areport = AnnualReport.find(areport_id)
    areport.update(pdf: nil)
    pdf = ApplicationController.new.render_to_string pdf: 'annual_report.pdf',
                                                     template: 'business/annual_reports/annual_report.pdf.erb', encoding: 'UTF-8',
                                                     locals: { annual_report: areport, business: areport.business },
                                                     margin: { top:               0,
                                                               bottom:            0,
                                                               left:              0,
                                                               right:             0 }
    uploader = PdfUploader.new(:store)
    file = Tempfile.new(["annual_report_#{areport.id}", '.pdf'])
    file.binmode
    file.write(pdf)
    file.rewind
    uploaded_file = uploader.upload(file)
    areport.update(pdf_data: uploaded_file.to_json, year: areport.review_end.year)
    file.delete
  end
end

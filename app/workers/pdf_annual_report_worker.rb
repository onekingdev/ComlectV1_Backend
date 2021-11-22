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
                                                     margin: { top: 12, bottom: 30, left: 0, right: 0 },
                                                     page_width: '8.5in', page_height: '11in'
    uploader = PdfUploader.new(:store)
    file = Tempfile.new(["annual_report_#{areport.id}", '.pdf'])
    file.binmode
    file.write(pdf)
    file.rewind
    loaded_pdf = CombinePDF.load(file.path)
    loaded_pdf.number_pages(location: [:bottom], font_size: 8, margin_from_side: 0, margin_from_height: 20, start_at: 1, page_range: (1..loaded_pdf.pages.count))
    loaded_pdf.save file.path
    uploaded_file = uploader.upload(file)
    areport.update(pdf_data: uploaded_file.to_json, year: areport.review_end.year)
    file.delete
  end
end

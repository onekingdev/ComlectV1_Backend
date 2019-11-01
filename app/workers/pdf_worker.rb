# frozen_string_literal: true

require 'rubygems'
require 'libreconv'

class PdfWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(policy_doc)
    tmp_fd = Tempfile.new(['pdf-', '.pdf'])
    Libreconv.convert(policy_doc.doc_url, tmp_fd.path)
    uploader = PdfUploader.new(:store)
    file = File.new(tmp_fd)
    uploaded_file = uploader.upload(file)
    policy_doc.update(pdf_data: uploaded_file.to_json)
  end
end

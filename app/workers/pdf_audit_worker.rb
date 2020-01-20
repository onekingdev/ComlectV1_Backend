# frozen_string_literal: true

class PdfAuditWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def env_path(in_path)
    Rails.env.production? ? in_path : "#{Rails.root}/public#{in_path}"
  end

  def perform(audit_doc_id)
    audit_doc = AuditDoc.find(audit_doc_id)
    tmp_fd = Tempfile.new(['pdf-', '.pdf'])
    Libreconv.convert(env_path(audit_doc.file_url), tmp_fd.path)
    uploader = PdfUploader.new(:store)
    file = File.new(tmp_fd)
    uploaded_file = uploader.upload(file)
    audit_doc.update(pdf_data: uploaded_file.to_json, processed: true)
  end
end

# frozen_string_literal: true
class FileUploader < Shrine
  plugin :activerecord
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :validation_helpers
  plugin :pretty_location

  # Shrine validations are not firing for some reason
  Attacher.validate do
    validate_max_size 2.megabytes, message: 'is too large (max is 2 MB)'
    validate_mime_type_inclusion %w(application/pdf), message: 'is not a PDF file'
  end
end

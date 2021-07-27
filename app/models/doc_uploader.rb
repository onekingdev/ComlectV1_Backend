# frozen_string_literal: true

class DocUploader < Shrine
  plugin :activerecord
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :validation_helpers
  plugin :pretty_location

  Attacher.validate do
    validate_max_size 10.megabytes, message: 'is too large (max is 10 MB)'
    # rubocop:disable Metrics/LineLength
    validate_mime_type_inclusion %w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document], message: 'is not a document file'
    # rubocop:enable Metrics/LineLength
  end
end

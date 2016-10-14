# frozen_string_literal: true
class FileUploader < Shrine
  plugin :activerecord
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :validation_helpers
  plugin :pretty_location
end

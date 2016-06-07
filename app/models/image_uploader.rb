# frozen_string_literal: true
require "image_processing/mini_magick"

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :versions, names: %i(original thumb)
  plugin :pretty_location
  plugin :cached_attachment_data

  Attacher.validate do
    validate_max_size 1.megabyte, message: 'is too large (max is 1 MB)'
    validate_mime_type_inclusion %w(image/jpeg image/png image/gif)
  end

  def process(io, context)
    case context[:phase]
    when :store
      thumb = resize_to_limit!(io.download, 200, 200)
      { original: io, thumb: thumb }
    end
  end
end

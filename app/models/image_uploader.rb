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

  # Shrine validations are not firing for some reason
  Attacher.validate do
    validate_max_size 2.megabytes, message: 'is too large (max is 2 MB)'
    validate_mime_type_inclusion %w(image/jpeg image/png image/gif), message: 'is not a supported image type'
  end

  def process(io, context)
    case context[:phase]
    when :store
      thumb = resize_to_limit!(io.download, 200, 200)
      circle = resize_and_pad!(io.download, 200, 200)
      profile = resize_and_pad!(io.download, 300, 300)
      { original: io, thumb: thumb, profile: profile, circle: circle }
    end
  end
end

# frozen_string_literal: true

require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :activerecord
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :processing
  plugin :versions
  plugin :pretty_location

  Attacher.validate do
    validate_max_size 2.megabytes, message: 'is too large (max is 2 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif], message: 'is not a supported image type'
  end

  process(:store) do |io, _context|
    thumb = ImageProcessing::MiniMagick.source(io.download).resize_and_pad!(200, 200)
    profile = ImageProcessing::MiniMagick.source(io.download).resize_and_pad!(300, 300)
    { original: io, thumb: thumb, profile: profile }
  end
end

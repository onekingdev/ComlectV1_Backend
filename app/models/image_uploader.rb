# frozen_string_literal: true
require "image_processing/mini_magick"

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :activerecord
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :processing
  plugin :versions
  plugin :pretty_location

  process(:store) do |io, _context|
    thumb = resize_to_fill!(io.download, 200, 200)
    profile = resize_to_fill!(io.download, 300, 300)
    { original: io, thumb: thumb, profile: profile }
  end
end

# frozen_string_literal: true
class Business::LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  def content_type_whitelist
    /image\/(jpeg|png|gif)/
  end
end

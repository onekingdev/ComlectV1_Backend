# frozen_string_literal: true
CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = "fog/aws"
    config.aws_credentials = {
      access_key_id:     ENV.fetch("S3_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("S3_SECRET_ACCESS_KEY"),
      region:            ENV.fetch("S3_REGION")
    }
    config.aws_bucket = ENV.fetch("S3_BUCKET")
    config.aws_acl = "public-read"
    config.storage = :aws
  else
    config.storage = :file
  end
end

# frozen_string_literal: true

require 'shrine'

# rubocop:disable Rails/EnvironmentComparison
if Rails.env.production? || Rails.env == 'staging'
  require 'shrine/storage/s3'

  s3_options = {
    access_key_id:     ENV.fetch('S3_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('S3_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('S3_REGION'),
    bucket:            ENV.fetch('S3_BUCKET')
  }

  Shrine.storages = {
    store: Shrine::Storage::S3.new(prefix: 'store', upload_options: { acl: 'public-read' }, **s3_options),
    cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options)
  }
else
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  }
end
# rubocop:enable Rails/EnvironmentComparison

Shrine.plugin :keep_files, cached: true, replaced: true

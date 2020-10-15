# frozen_string_literal: true

class ZipFolderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(folder_id)
    folder = FileFolder.find folder_id
    folder.create_zip(folder)
  end
end

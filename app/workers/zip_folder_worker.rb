# frozen_string_literal: true

class ZipFolderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(folder_id)
    folder = FileFolder.find folder_id
    filename = "#{folder.name}.zip"
    temp_file = Tempfile.new(filename)
    folder.create_zip(folder, temp_file)
  end
end

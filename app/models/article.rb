# frozen_string_literal: true

class Article < ActiveRecord::Base
  include ImageUploader[:image]
  include PdfUploader[:pdf]

  def to_s
    title
  end
end

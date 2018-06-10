# frozen_string_literal: true

class Article < ActiveRecord::Base
  include ImageUploader[:image]

  def to_s
    title
  end
end

# frozen_string_literal: true

class Partnership < ActiveRecord::Base
  include ImageUploader[:logo]

  def to_s
    company
  end
end

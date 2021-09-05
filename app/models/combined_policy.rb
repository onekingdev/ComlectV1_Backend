# frozen_string_literal: true

class CombinedPolicy < ApplicationRecord
  belongs_to :business
  include PdfUploader[:file]
end

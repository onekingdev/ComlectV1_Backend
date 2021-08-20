# frozen_string_literal: true

class AnnualReport < ActiveRecord::Base
  belongs_to :business
  has_many :reminders, as: :linkable
  has_many :annual_review_employees, dependent: :destroy
  has_many :regulatory_changes, dependent: :destroy
  has_many :review_categories, dependent: :destroy
  accepts_nested_attributes_for :annual_review_employees, allow_destroy: true
  accepts_nested_attributes_for :regulatory_changes, allow_destroy: true
  include PdfUploader[:pdf]

  validates :name, presence: true
  validate if: -> { review_end.present? } do
    errors.add :review_start, :past if review_start > review_end
  end
end

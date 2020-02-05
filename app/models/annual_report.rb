# frozen_string_literal: true

class AnnualReport < ActiveRecord::Base
  belongs_to :business
  has_many :annual_review_employees, dependent: :destroy
  has_many :regulatory_changes, dependent: :destroy
  has_many :business_changes, dependent: :destroy
  has_many :findings, dependent: :destroy
  accepts_nested_attributes_for :annual_review_employees, allow_destroy: true
  accepts_nested_attributes_for :regulatory_changes, allow_destroy: true
  accepts_nested_attributes_for :business_changes, allow_destroy: true
  accepts_nested_attributes_for :findings, allow_destroy: true
  # after_save :destroy_empties
  include PdfUploader[:pdf]

  def cof_str
    if cof_bits.nil?
      '0000000000000000000000000000000000'
    else
      cof_bits.to_s(2).rjust(34, '0').reverse
    end
  end

  def score
    max_score = cof_str.length
    cur_score = cof_str.split('').map(&:to_i).inject(0) { |sum, x| sum + x }
    (cur_score * 100 / max_score).to_i
  end

  def ready?
    result = true
    %i[exam_start exam_end review_start review_end tailored_lvl].each do |a|
      result = false if public_send(a).nil?
    end
    if score == 100 && result
      result
    else
      false
    end
  end
end

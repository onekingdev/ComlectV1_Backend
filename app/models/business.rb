# frozen_string_literal: true
class Business < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :industries
  has_many :projects, dependent: :destroy
  has_one :payment_profile, dependent: :destroy

  include ImageUploader[:logo]

  EMPLOYEE_OPTIONS = %w(<10 11-50 51-100 100+).freeze

  validates :contact_first_name, :contact_last_name, :contact_email, presence: true
  validates :business_name, :industries, :employees, :description, presence: true
  validates :country, :city, :state, presence: true
  validates :description, length: { maximum: 750 }
  validates :employees, inclusion: { in: EMPLOYEE_OPTIONS }

  accepts_nested_attributes_for :user

  def self.for_signup(attributes = {})
    new(attributes).tap do |business|
      business.build_user unless business.user
    end
  end

  def public?
    !anonymous?
  end
end

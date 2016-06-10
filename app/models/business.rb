# frozen_string_literal: true
class Business < ActiveRecord::Base
  belongs_to :user
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :jurisdictions

  include ImageUploader[:logo]

  INDUSTRIES = %w(Broker-Dealer Banking Fund\ Manager Investment\ Adviser Commodities\ Trader).freeze
  EMPLOYEE_OPTIONS = %w(<10 11-50 51-100 100+).freeze

  validates :contact_first_name, :contact_last_name, :contact_email, presence: true
  validates :business_name, :industry, :employees, :description, presence: true
  validates :country, :city, :state, presence: true
  validates :description, length: { maximum: 750 }
  validates :industry, inclusion: { in: INDUSTRIES }
  validates :employees, inclusion: { in: EMPLOYEE_OPTIONS }

  accepts_nested_attributes_for :user

  def self.for_signup(attributes = {})
    new(attributes).tap do |business|
      business.build_user unless business.user
    end
  end
end

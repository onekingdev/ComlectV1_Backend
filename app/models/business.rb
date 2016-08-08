# frozen_string_literal: true
class Business < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :industries
  has_many :projects, dependent: :destroy
  has_one :payment_profile, dependent: :destroy
  has_many :project_invites, dependent: :destroy
  has_many :favorites, as: :owner
  has_many :favorited_by, as: :favorited, dependent: :destroy, class_name: 'Favorite'
  has_many :favorite_specialists, through: :favorites, source: :favorited, source_type: 'Specialist'

  include ImageUploader[:logo]

  EMPLOYEE_OPTIONS = %w(<10 11-50 51-100 100+).freeze

  validates :contact_first_name, :contact_last_name, :contact_email, presence: true
  validates :business_name, :industries, :employees, :description, presence: true
  validates :country, :city, :state, presence: true
  validates :description, length: { maximum: 750 }
  validates :employees, inclusion: { in: EMPLOYEE_OPTIONS }
  validate :validate_logo

  accepts_nested_attributes_for :user

  def self.for_signup(attributes = {})
    new(attributes).tap do |business|
      business.build_user unless business.user
    end
  end

  def public?
    !anonymous?
  end

  private

  # Shrine validations are not firing for some reason
  def validate_logo
    if logo && logo_data_changed?
      errors.add :logo, :too_large if logo.metadata['size'] > 2.megabytes
      errors.add :logo, :invalid unless %w(image/jpeg image/png image/gif).include?(logo.metadata['mime_type'])
    end
  end
end

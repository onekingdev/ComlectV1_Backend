# frozen_string_literal: true
class Specialist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :skills
  has_many :work_experiences, dependent: :delete_all
  has_many :education_histories, dependent: :delete_all

  scope :preload_associations, -> {
    includes(:user, :work_experiences, :education_histories, :industries, :jurisdictions, :skills)
  }

  include ImageUploader[:photo]
  include FileUploader[:resume]

  enum visibility:  { is_public: 'public', is_private: 'private' }

  def to_s
    [first_name, last_name].map(&:presence).compact.join(' ')
  end

  def public?
    is_public?
  end

  def private?
    is_private?
  end
end

# frozen_string_literal: true
class Specialist::Form < Specialist
  include ApplicationForm

  validates :first_name, :last_name, :country, :zipcode, presence: true

  accepts_nested_attributes_for :user

  attr_accessor :public_profile

  def self.signup(attributes = {})
    new(attributes).tap do |specialist|
      specialist.build_user unless specialist.user
      specialist.work_experiences.build unless specialist.work_experiences.any?
      specialist.education_histories.build unless specialist.education_histories.any?
    end
  end

  def public_profile
    @public_profile.nil? ? public? : @public_profile
  end

  def public_profile=(is_public)
    @public_profile = is_public
    self.visibility = is_public ? visibilities(:is_public) : visibilities(:is_private)
  end
end

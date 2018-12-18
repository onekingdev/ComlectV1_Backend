# frozen_string_literal: true

class Specialist::Form < Specialist
  include ApplicationForm

  accepts_nested_attributes_for :work_experiences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :education_histories, allow_destroy: true, reject_if: :all_blank

  validates :first_name, :last_name, :country, :time_zone, :address_1, :industry_ids, :jurisdiction_ids, presence: true
  validate :validate_minimum_experience, on: :signup

  accepts_nested_attributes_for :user

  before_save :destroy_photo
  before_save :destroy_resume

  attr_accessor :public_profile
  attr_writer :delete_photo, :delete_resume

  def self.signup(attributes = {}, token = nil)
    invitation = attributes.delete(:invitation)
    tos_acceptance_ip = attributes.delete(:tos_acceptance_ip)

    new(attributes).tap do |specialist|
      specialist.specialist_team_id = invitation.specialist_team_id if invitation
      binding.pry
      specialist.build_user.build_tos_agreement.build_cookie_agreement unless specialist.user
      specialist.user.tos_acceptance_date = Time.zone.now
      specialist.user.tos_acceptance_ip = tos_acceptance_ip
      specialist.work_experiences.build unless specialist.work_experiences.any?
      specialist.education_histories.build unless specialist.education_histories.any?
      referral_token = ReferralToken.find_by(token: token) if token
      specialist.build_referral(referral_token: referral_token) if referral_token
    end
  end

  def self.for_user(user)
    where(user_id: user.id).first!
  end

  def skill_names
    @skill_names.nil? ? skills.map(&:name) : @skill_names
  end

  def skill_names=(names)
    self.skills = names.map do |name|
      Skill.find_or_initialize_by(name: name)
    end
  end

  def public_profile
    @public_profile.nil? ? public? : @public_profile
  end

  def public_profile=(is_public)
    @public_profile = ActiveRecord::Type::Boolean.new.type_cast_from_database(is_public)
    self.visibility = @public_profile ? Specialist.visibilities[:is_public] : Specialist.visibilities[:is_private]
  end

  def delete_photo
    @delete_photo ||= '0'
  end

  def delete_resume
    @delete_resume ||= '0'
  end

  def delete_photo?
    @delete_photo == '1'
  end

  def delete_resume?
    @delete_resume == '1'
  end

  private

  def validate_minimum_experience
    experience = work_experiences.select(&:compliance?).map(&:years).reduce(:+) || 0
    errors.add :work_experiences, :too_short if experience < 3
  end

  def destroy_photo
    self.photo = nil if @delete_photo == '1'
  end

  def destroy_resume
    self.resume = nil if @delete_resume == '1'
  end
end

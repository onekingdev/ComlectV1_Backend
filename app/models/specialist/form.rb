# frozen_string_literal: true

class Specialist::Form < Specialist
  include ApplicationForm

  validates :first_name, :last_name, :country, :time_zone, :address_1, :industry_ids, :jurisdiction_ids, presence: true, on: :signup
  # validates :industry_ids, :jurisdiction_ids, presence: false, allow_blank: true, on: :employee

  accepts_nested_attributes_for :user

  before_save :destroy_photo
  before_save :destroy_resume

  attr_accessor :public_profile
  attr_writer :delete_photo, :delete_resume

  def self.signup(attributes = {}, token = nil)
    invitation = attributes.delete(:invitation)
    tos_acceptance_ip = attributes.delete(:tos_acceptance_ip)

    new(attributes).tap do |specialist|
      specialist.team_id = invitation.team_id if invitation
      specialist.build_user.build_tos_agreement.build_cookie_agreement unless specialist.user
      specialist.user.tos_acceptance_date = Time.zone.now
      specialist.user.tos_acceptance_ip = tos_acceptance_ip
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

  # something strange here
  # we have this method as `attr_accessor`
  # rubocop:disable Lint/DuplicateMethods
  def public_profile
    @public_profile.nil? ? public? : @public_profile
  end

  def public_profile=(is_public)
    @public_profile = ActiveRecord::Type::Boolean.new.type_cast_from_database(is_public)
    self.visibility = @public_profile ? Specialist.visibilities[:is_public] : Specialist.visibilities[:is_private]
  end
  # rubocop:enable Lint/DuplicateMethods

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

  def destroy_photo
    self.photo = nil if @delete_photo == '1'
  end

  def destroy_resume
    self.resume = nil if @delete_resume == '1'
  end
end

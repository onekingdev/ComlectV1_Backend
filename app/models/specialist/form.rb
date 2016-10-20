# frozen_string_literal: true
class Specialist::Form < Specialist
  include ApplicationForm

  accepts_nested_attributes_for :work_experiences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :education_histories, allow_destroy: true, reject_if: :all_blank

  validates :first_name, :last_name, :country, :time_zone, :address_1, presence: true
  validate :validate_minimum_experience

  accepts_nested_attributes_for :user

  attr_accessor :public_profile

  def self.signup(attributes = {})
    new(attributes).tap do |specialist|
      specialist.build_user unless specialist.user
      specialist.work_experiences.build unless specialist.work_experiences.any?
      specialist.education_histories.build unless specialist.education_histories.any?
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

  private

  def validate_minimum_experience
    experience = work_experiences.select(&:compliance?).map(&:years).reduce(:+) || 0
    errors.add :work_experiences, :too_short if experience < 3
  end
end

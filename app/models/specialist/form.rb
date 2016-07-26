# frozen_string_literal: true
class Specialist::Form < Specialist
  include ApplicationForm

  accepts_nested_attributes_for :work_experiences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :education_histories, allow_destroy: true, reject_if: :all_blank

  validates :first_name, :last_name, :country, :zipcode, presence: true
  validate :validate_photo, :validate_resume

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

  # Shrine validations are not firing for some reason
  def validate_photo
    if photo && photo_data_changed?
      errors.add :photo, :too_large if photo.metadata['size'] > 2.megabytes
      errors.add :photo, :invalid unless %w(image/jpeg image/png image/gif).include?(photo.metadata['mime_type'])
    end
  end

  def validate_resume
    if resume && resume_data_changed?
      errors.add :resume, :too_large if resume.metadata['size'] > 2.megabytes
      errors.add :resume, :invalid unless %w(application/pdf).include?(resume.metadata['mime_type'])
    end
  end
end

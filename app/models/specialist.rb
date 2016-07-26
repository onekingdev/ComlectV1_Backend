# frozen_string_literal: true
class Specialist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :skills
  has_many :work_experiences, dependent: :delete_all
  has_many :education_histories, dependent: :delete_all

  include ImageUploader[:photo]
  include FileUploader[:resume]

  accepts_nested_attributes_for :work_experiences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :education_histories, allow_destroy: true, reject_if: :all_blank

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

  def skill_names
    @skill_names.nil? ? skills.map(&:name) : @skill_names
  end

  def skill_names=(names)
    self.skills = names.map do |name|
      Skill.find_or_initialize_by(name: name)
    end
  end
end

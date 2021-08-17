# frozen_string_literal: true

# Required fields for specialist onboarding:
# ==========================================
# Jurisdiction
# Your time zone
# Industry
# Sub-industry
# Former regulator
# Specialist other if former regulator => true
# Experience

class SpecialistSignupOnboardingService < ApplicationService
  attr_reader :specialist, :params

  def initialize(specialist, params)
    @specialist = specialist
    @params = params
    @success = true
  end

  def success?
    @success
  end

  def call
    assign_attributes

    unless specialist.save(context: :onboarding)
      @success = false
    end

    self
  end

  private

  def assign_attributes
    specialist.tap do |specialist|
      specialist.jurisdiction_ids = params[:jurisdiction_ids]
      specialist.time_zone = params[:time_zone]
      specialist.industry_ids = params[:industry_ids]
      specialist.former_regulator = params[:former_regulator]
      specialist.experience = params[:experience]
      specialist.resume = params[:resume]
    end

    if specialist.username.blank?
      specialist.username = specialist.generate_username
    end

    if params[:sub_industry_ids].present?
      specialist.assign_attributes(
        sub_industries: convert_sub_industries(params[:sub_industry_ids])
      )
    end

    if specialist.former_regulator && params[:specialist_other].present?
      specialist.specialist_other = params[:specialist_other]
    end

    set_skills
  end

  def convert_sub_industries(ids)
    return [] if ids.blank?

    tgt_industries = []
    ids.each do |sub_ind|
      c = sub_ind.split('_').map(&:to_i)
      if specialist.industries.collect(&:id).include? c[0]
        tgt_industries.push(Industry.find(c[0]).sub_industries_specialist.split("\r\n")[c[1]])
      end
    end

    tgt_industries
  end

  def set_skills
    skill_names = params[:skill_names]
    return if skill_names.blank?

    skills = skill_names.map do |skill_name|
      Skill.find_or_create_by(name: skill_name)
    end

    specialist.skills = skills
  end
end

# frozen_string_literal: true

# Required fields for specialist onboarding:
# ==========================================
# Jurisdiction
# Your time zone
# Industry
# Former regulator
# Specialist other if former regulator => true
# Experience
#
# Optional fields
# ===============
# Sub-industry

module SpecialistServices
  class SignupOnboardingService < ApplicationService
    attr_reader :specialist, :params

    def initialize(specialist, params)
      @specialist = specialist
      @params = params
      @success = true
    end

    def success?
      @success
    end

    def context
      return @params[:context].to_sym if @params[:context]
      :onboarding
    end

    def set_attributes
      case @params[:context]
      when 'skills'
        set_skills
      when 'setting'
        update_setting
      else
        assign_attributes
      end
    end

    def call
      set_attributes
      unless specialist.save(context: context)
        @success = false
      end

      self
    end

    private

    def assign_attributes
      specialist.tap do |specialist|
        specialist.jurisdiction_ids = params[:jurisdiction_ids]
        specialist.time_zone = params[:time_zone] if params[:time_zone]
        specialist.industry_ids = params[:industry_ids]
        specialist.former_regulator = params[:former_regulator]
        specialist.experience = params[:experience] if params[:experience]
        specialist.description = params[:description] if params[:description]
        specialist.resume = params[:resume] if params[:resume]
        specialist.first_name = params[:first_name] if params[:first_name]
        specialist.last_name = params[:last_name] if params[:last_name]
        specialist.visibility = params[:visibility] if params[:visibility]
      end

      if params[:photo].present?
        specialist.photo = params[:photo] if params[:photo].class.to_s == 'ActionDispatch::Http::UploadedFile'
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

      skills = skill_names.select(&:present?).map do |skill_name|
        Skill.find_or_create_by(name: skill_name)
      end

      specialist.skills = skills
    end

    def update_setting
      specialist.min_hourly_rate = params[:min_hourly_rate]
      specialist.experience = params[:experience]
      specialist.name_setting = params[:name_setting] if params[:name_setting]
    end
  end
end

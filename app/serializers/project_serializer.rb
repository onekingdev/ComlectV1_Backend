# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :id,
             :business_id,
             :type,
             :status,
             :title,
             :location_type,
             :location,
             :description,
             :key_deliverables,
             :starts_on,
             :ends_on,
             :pricing_type,
             :payment_schedule,
             :fixed_budget,
             :hourly_rate,
             :estimated_hours,
             :only_regulators,
             :annual_salary,
             :fee_type,
             :created_at,
             :updated_at,
             :tsv,
             :calculated_budget,
             :lat,
             :lng,
             :point,
             :specialist_id,
             :job_applications_count,
             :published_at,
             :completed_at,
             :hired_at,
             :extended_at,
             :starts_in_48,
             :ends_in_24,
             :minimum_experience,
             :expires_at,
             :solicited_business_rating,
             :solicited_specialist_rating,
             :duration_type,
             :estimated_days,
             :rfp_timing,
             :est_budget,
             :applicant_selection,
             :business_fee_free,
             :color,
             :local_project_id,
             :skills,
             :jurisdictions,
             :industries

  def skills
    object.skills.map do |skill|
      {
        id: skill.id,
        name: skill.name
      }
    end
  end

  def jurisdictions
    object.jurisdictions.map do |jurisdiction|
      {
        id: jurisdiction.id,
        name: jurisdiction.name
      }
    end
  end

  def industries
    object.industries.map do |industrie|
      {
        id: industrie.id,
        name: industrie.name
      }
    end
  end
end

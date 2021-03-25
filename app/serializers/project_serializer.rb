# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  has_many :skills, serializer: SkillSerializer
  has_many :jurisdictions, serializer: JurisdictionSerializer
  has_many :industries, serializer: IndustrySerializer
  has_one :business, serializer: Specialist::BusinessSerializer
  has_one :specialist, serializer: Business::SpecialistSerializer
  has_one :end_request, serializer: ProjectEndSerializer
  has_one :extension, serializer: ProjectExtensionSerializer
  has_many :timesheets
  attributes :id,
             :end_request,
             :extension,
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
             :upper_hourly_rate,
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
             :role_details,
             :skills,
             :jurisdictions,
             :industries,
             :specialist,
             :business
end

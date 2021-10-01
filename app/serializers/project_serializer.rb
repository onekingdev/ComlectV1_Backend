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
             :business,
             :processed_amount

  def current_user
    scope
  end

  def processed_amount
    object.charges.collect(&:specialist_amount_in_cents).compact.sum / 100.0
  end

  def status
    return 'Complete' if object.complete?
    output_status = object.starts_on > Time.zone.now ? 'Not Started' : 'In Progress'
    return output_status if object.specialist_id
    output_status = 'Draft' if current_user.specialist && current_user.specialist.job_applications.where(project_id: object.id, status: 'draft').present?
    output_status = 'Pending' if current_user.specialist && current_user.specialist.job_applications.where(project_id: object.id, status: 'published').present?
    output_status
  end
end

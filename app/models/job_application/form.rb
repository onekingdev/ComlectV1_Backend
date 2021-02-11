# frozen_string_literal: true

class JobApplication::Form < JobApplication
  include ApplicationForm

  attr_accessor :prerequisites # Dummy to store related errors
  attr_accessor :hourly_payment_schedule, :fixed_payment_schedule
  before_validation :assign_pricing_type_fields

  validate -> { errors.add :prerequisites, :no_jurisdiction }, unless: :jurisdiction?
  validate -> { errors.add :prerequisites, :no_industry }, unless: :industry?
  validate -> { errors.add :prerequisites, :no_experience }, unless: :enough_experience?
  validate -> { errors.add :prerequisites, :no_regulator }, unless: :regulator?
  validate -> { errors.add :prerequisites, :no_payment_info }, unless: :payment_info? if Rails.env.production? || Rails.env.staging?

  RFP_FIELDS = %i[message key_deliverables pricing_type].freeze
  validates :message, presence: true
  # validates(*RFP_FIELDS, presence: true, if: :rfp?)
  # validates(:starts_on, presence: true, if: :rfp?)
  # validates(:ends_on, presence: true, if: :rfp?)
  # validates :hourly_rate, presence: true, if: :hourly_pricing?
  # validates :estimated_hours, presence: true, if: :hourly_pricing?
  validates :fixed_budget, presence: true, if: :fixed_pricing?
  # validates :hourly_payment_schedule, :hourly_rate,
  #          presence: true, if: -> { hourly_pricing? && payment_schedule.blank? }
  # validates :fixed_payment_schedule, :fixed_budget,
  #          presence: true, if: -> { fixed_pricing? && payment_schedule.blank? }
  validate if: -> { starts_on.present? } do
    errors.add :starts_on, :past if starts_on.in_time_zone(project.business.tz).to_date < project.business.tz.today
  end
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :starts_on, :invalid if starts_on > ends_on
  end
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :ends_on, :invalid if ends_on < starts_on
  end

  def self.apply!(specialist, project, params)
    application = new(params.merge(specialist: specialist, project: project))

    if application.save && !application.draft?
      Favorite.remove! specialist, project
      Notification::Deliver.project_application!(application) if project.interview?
      JobApplication::Accept.(application) if project.auto_match?
    end

    application
  end

  def confirm_delete
    "<br><br>Are you sure you want to delete this proposal?<h4 class='m-t-1'>#{project.title}</h4>
     This can't be undone and this proposal will no longer appear in your dashboard, even as a draft.".html_safe
  end

  private

  def fixed_pricing?
    rfp? && pricing_type == 'fixed'
  end

  def hourly_pricing?
    rfp? && pricing_type == 'hourly'
  end

  def jurisdiction?
    (project.jurisdiction_ids & specialist.jurisdiction_ids).any?
  end

  def industry?
    (project.industry_ids & specialist.industry_ids).any?
  end

  def enough_experience?
    exp = Specialist.by_experience.find(specialist.id).years_of_experience.to_f
    exp >= project.minimum_experience
  end

  def regulator?
    return true unless project.only_regulators?
    specialist.former_regulator?
  end

  def payment_info?
    return true if project.full_time? # No payment info required for full time roles
    specialist.manager.stripe_account&.verified?
  end

  def assign_pricing_type_fields
    if hourly_pricing?
      self.fixed_budget = nil
      self.payment_schedule = hourly_payment_schedule
    else
      self.hourly_rate = nil
      self.payment_schedule = fixed_payment_schedule
    end
    true
  end

  def hourly_payment_schedule
    @hourly_payment_schedule || payment_schedule
  end

  def fixed_payment_schedule
    @fixed_payment_schedule || payment_schedule
  end
end

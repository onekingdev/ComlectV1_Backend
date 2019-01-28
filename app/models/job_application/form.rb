# frozen_string_literal: true

class JobApplication::Form < JobApplication
  include ApplicationForm

  attr_accessor :prerequisites # Dummy to store related errors

  validate -> { errors.add :prerequisites, :no_jurisdiction }, unless: :jurisdiction?
  validate -> { errors.add :prerequisites, :no_industry }, unless: :industry?
  validate -> { errors.add :prerequisites, :no_experience }, unless: :enough_experience?
  validate -> { errors.add :prerequisites, :no_regulator }, unless: :regulator?
  validate -> { errors.add :prerequisites, :no_payment_info }, unless: :payment_info?

  def self.apply!(specialist, project, params)
    application = create params.merge(specialist: specialist, project: project)
    Favorite.remove! specialist, project
    Notification::Deliver.project_application!(application) if project.interview?
    JobApplication::Accept.(application) if project.auto_match?
    application
  end

  private

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
end

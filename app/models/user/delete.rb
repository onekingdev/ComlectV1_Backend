# frozen_string_literal: true

class User::Delete < Draper::Decorator
  decorates User
  delegate_all

  def self.call(user)
    new(user).delete
  end

  def delete
    business ? delete_business : delete_specialist
    update_columns deleted: true, deleted_at: Time.zone.now
    true
  end

  private

  def delete_business
    delete_projects business_projects
    business.payment_profile&.destroy
  end

  def delete_specialist
    delete_projects specialist_projects
    specialist.stripe_account&.destroy
  end

  def delete_projects(projects)
    projects.where.not(status: Project.statuses.fetch(:complete)).destroy_all
  end
end

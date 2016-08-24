# frozen_string_literal: true
class ProjectInvite::Form < Draper::Decorator
  decorates ProjectInvite
  delegate_all

  validates :message, presence: true

  def self.for(specialist, project)
    message = I18n.t('project_invites.message_template',
                     specialist: specialist.first_name,
                     project_or_job: project.full_time? ? 'job' : 'project',
                     company_name: project.business.to_s).strip
    invite = ProjectInvite.new specialist: specialist, project: project, message: message
    decorate invite
  end

  def self.new_from_params(params, business)
    invite = business.project_invites.new(params)
    decorate invite
  end

  def save_and_send
    return false if invalid?
    save!
    send_message!
  end

  def new_project?
    project.nil? || project.new_record?
  end

  def existing_project?
    !new_project?
  end
end

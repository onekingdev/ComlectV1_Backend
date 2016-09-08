# frozen_string_literal: true
class ProjectInvite::Form < Draper::Decorator
  decorates ProjectInvite
  delegate_all

  attr_accessor :business

  validates :message, presence: true

  TEMPLATES = {
    invite: 'project_invites.message_templates.invite',
    hire_again: 'project_invites.message_templates.hire_again'
  }.freeze

  def self.for(specialist, project, template: :invite)
    message = I18n.t(TEMPLATES.fetch(template.to_s.to_sym, TEMPLATES[:invite]),
                     specialist: specialist.first_name,
                     project_or_job: project.full_time? ? 'job' : 'project',
                     company_name: project.business.to_s).strip
    invite = ProjectInvite.new specialist: specialist, project: project, message: message
    decorate(invite).tap do |form|
      form.business = project.business
    end
  end

  def self.new_from_params(params, business)
    project = business.projects.find(params.delete(:project_id)) if params[:project_id].present?
    invite = business.project_invites.new(params.merge(project: project))
    decorate(invite).tap do |form|
      form.business = business
    end
  end

  def available_projects
    business.projects.published.pending
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

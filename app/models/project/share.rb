# frozen_string_literal: true
class Project::Share
  include ActiveModel::Model

  attr_accessor :name, :email, :message, :project, :user

  validates :name, :email, presence: true
  validates :message, presence: true, if: -> { user.business }

  def self.for(project, attributes = {})
    new(attributes).tap do |share|
      share.project = project
      share.set_message
    end
  end

  def set_message
    return self.message = specialist_message if user.specialist
    self.message = business_message unless message.present?
  end

  def send!
    ProjectMailer.deliver_later :share, project, name, email, message
  end

  private

  def specialist_message
    I18n.t("project_shares.message_template.from_specialist",
           recipient_name: name,
           sender_name: user.specialist.first_name,
           project_job: "#{project.title} #{project.one_off? ? 'project' : 'job'}").strip
  end

  def business_message
    type = project.one_off? ? 'project' : 'job'
    I18n.t("project_shares.message_template.from_business.#{type}",
           project_title: project.title,
           company_name: user.business.business_name).strip
  end
end

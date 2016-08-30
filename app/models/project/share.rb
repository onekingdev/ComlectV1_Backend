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
    return self.message = nil if user.specialist
    self.message = message_template unless message.present?
  end

  def send!
    ProjectMailer.share(project, name, email, message, user).deliver_later
  end

  private

  def message_template
    type = project.one_off? ? 'project' : 'job'
    I18n.t("project_shares.message_template.from_business.#{type}",
           project_title: project.title,
           company_name: user.business.business_name)
  end
end

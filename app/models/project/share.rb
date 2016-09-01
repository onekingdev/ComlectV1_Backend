# frozen_string_literal: true
class Project::Share
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_accessor :name, :email, :message, :message_html, :project, :user

  validates :email, presence: true
  validates :message, presence: true, if: -> { user.business }

  def self.for(project, attributes = {})
    new(attributes).tap do |share|
      share.project = project
      share.user.specialist ? share.set_specialist_message : share.set_business_message
    end
  end

  def set_specialist_message
    self.message = specialist_message_text
    self.message_html = specialist_message_html
  end

  def set_business_message
    self.message = business_message unless message.present?
    self.message_html = simple_format message
  end

  def send!
    ProjectMailer.deliver_later :share, project, name, email, message, message_html
  end

  private

  def specialist_message_text
    I18n.t("project_shares.message_template.from_specialist",
           recipient_name: name,
           sender_name: user.specialist.first_name,
           project_job: "#{project.title} #{project.one_off? ? 'project' : 'job'}").strip
  end

  def specialist_message_html
    simple_format I18n.t(
      "project_shares.message_template.from_specialist",
      recipient_name: name,
      sender_name: user.specialist.first_name,
      project_job: "%{project_job_link} #{project.one_off? ? 'project' : 'job'}"
    ).strip
  end

  def business_message
    type = project.one_off? ? 'project' : 'job'
    I18n.t("project_shares.message_template.from_business.#{type}",
           project_title: project.title,
           company_name: user.business.business_name).strip
  end
end

# frozen_string_literal: true

class Project::Share
  include ActiveModel::Model
  include ActionView::Helpers::TextHelper

  attr_accessor :email, :message_html, :project, :user

  validates :email, presence: true

  def self.for(project, attributes = {})
    new(attributes).tap do |share|
      share.project = project
      share.user.specialist ? share.set_specialist_message : share.set_business_message
    end
  end

  def set_specialist_message
    self.message_html = specialist_message_html
  end

  def set_business_message
    self.message = business_message if message.blank?
    self.message_html = simple_format message
  end

  def send!
    ProjectMailer.share(project, email, message_html).deliver
  end

  private

  def specialist_message_html
    simple_format I18n.t(
      'project_shares.message_template.from_specialist',
      sender_name: user.specialist.full_name,
      project_job: "%{project_job_link} #{project.full_time? ? 'job' : 'project'}"
    ).strip
  end

  def business_message
    type = project.full_time? ? 'job' : 'project'

    I18n.t(
      "project_shares.message_template.from_business.#{type}",
      project_title: project.title,
      company_name: user.business.business_name
    ).strip
  end
end

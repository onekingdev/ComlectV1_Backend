# frozen_string_literal: true

class ProjectMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def invite(invite)
    mail to: invite.specialist.user.email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "You've been invited to a project",
           message_html: invite_message_html(invite),
           message_text: invite_message_text(invite)
         }
  end

  def share(project, name, email, message_text, message_html)
    @project_url = project_url(project)
    @message_text = add_project_link(project, message_text, @project_url, :text)
    @message_html = add_project_link(project, message_html, @project_url, :html)
    mail to: "#{name} <#{email}>",
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: (project.full_time? ? 'Full-time role' : 'Project') + ' you might be interested in',
           message_html: render('share.html'),
           message_text: render('share.text')
         }
  end

  def end_request(project)
    @project = project
    specialist = project.specialist
    mail to: "#{specialist.full_name} <#{specialist.user.email}>",
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "#{project.title} Ending",
           message_html: render('end_request.html'),
           message_text: render('end_request.text')
         }
  end

  def extension_request(project)
    @project = project
    specialist = project.specialist
    mail to: "#{specialist.full_name} <#{specialist.user.email}>",
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "Project Extension Request",
           message_html: render('extension_request.html'),
           message_text: render('extension_request.text')
         }
  end

  private

  def add_project_link(project, text, url, format = :html)
    found = text =~ /%\{project_job_link\}/
    replacement = case [format, !found.nil?]
                  when [:html, true]
                    "<a href='#{url}'>#{project.title}</a>".html_safe
                  when [:html, false]
                    "<p>Project Link: <a href='#{url}'>#{project.title}</a></p>".html_safe
                  when [:text, true]
                    url
                  else # [:text, false]
                    "\n\nProject Link: #{url}"
                  end
    found ? text.gsub('%{project_job_link}', replacement) : text + replacement
  end

  def invite_message_html(invite)
    url = project_url(invite.project)
    simple_format(invite.message) + "<br>Project Link: <a href='#{url}'>#{invite.project}</a>".html_safe
  end

  def invite_message_text(invite)
    url = project_url(invite.project)
    invite.message + "\n\nProject Link: #{url}"
  end
end

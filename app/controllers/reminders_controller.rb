# frozen_string_literal: true

class RemindersController < ApplicationController
  before_action :require_someone!
  require 'csv'

  def index
    respond_to do |format|
      format.csv do
        csv_a = []
        @remindable = @current_someone
        tgt_from_date = @remindable.created_at - 1.year
        tgt_to_date = Time.zone.today + 1.year

        if params[:from_date].present?
          tgt_from_date = Date.parse(params[:from_date])
          tgt_to_date = Date.parse(params[:to_date])
        end
        csv_a.push(['Name', 'Linked to', 'Assignee', 'Start Date', 'End Date', 'Completion Date', 'Description', 'Attachments'])
        reminders = Reminder.get_all_reminders(@remindable, tgt_from_date, tgt_to_date, params[:skip_projects].present?)
        if reminders.count.positive?
          reminders.each do |reminder|
            csv_a.push([
                         reminder.body,
                         ((reminder.linkable.present? ? reminder.linkable.name : '') if reminder.class.name != 'Project'),
                         (reminder.assignee.present? ? reminder.assignee.name : ''),
                         (reminder&.remind_at&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y')),
                         (reminder&.end_date&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y')),
                         (reminder&.done_at&.in_time_zone(@remindable.time_zone)&.strftime('%b %-d, %Y') if reminder.done_at.present?),
                         (reminder&.description if reminder.class.name != 'Project'),
                         reminder.messages&.where&.not(file_data: nil)&.count || 0
                       ])
          end
        end
        @csv_a = csv_a
        headers['Content-Disposition'] = 'attachment; filename="calendar.csv"'
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end

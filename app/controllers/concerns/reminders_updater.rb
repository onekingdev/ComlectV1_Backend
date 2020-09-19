# frozen_string_literal: true

module RemindersUpdater
  def skip_occurence(remindable)
    src_reminder = remindable.reminders.find(params[:src_id])
    src_reminder.update(skip_occurencies: src_reminder.skip_occurencies + [params[:oid].to_i])
  end

  def change_reminder_state
    if params[:oid].present?
      if params[:done] == 'false'
        @reminder.update(done_occurencies: @reminder.done_occurencies - [params[:oid].to_i])
      else
        @reminder.update(done_occurencies: @reminder.done_occurencies + [params[:oid].to_i])
      end
    else
      @reminder.update(done_at: (params[:done] == 'false' ? nil : Time.zone.now.in_time_zone(@reminder.remindable.time_zone)))
    end
  end
end

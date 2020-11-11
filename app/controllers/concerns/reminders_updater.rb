# frozen_string_literal: true

module RemindersUpdater
  def skip_occurence(remindable)
    src_reminder = remindable.reminders.find(params[:src_id])
    src_reminder.update(skip_occurencies: src_reminder.skip_occurencies + [params[:oid].to_i])
  end

  def change_reminder_state(note)
    upd_time = Time.zone.now.in_time_zone(@reminder.remindable.time_zone)
    if params[:oid].present?
      if params[:done] == 'false'
        @reminder.update(done_occurencies: @reminder.done_occurencies.tap { |hs| hs.delete(params[:oid].to_i) })
      else
        @reminder.update(done_occurencies: @reminder.done_occurencies.merge(params[:oid].to_i => [upd_time, note]))
      end
    else
      @reminder.update(done_at: (params[:done] == 'false' ? nil : upd_time), note: note)
    end
  end
end

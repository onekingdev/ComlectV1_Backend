# frozen_string_literal: true

class RecurringReminderSerializer < ApplicationSerializer
  attributes :id,
             :body,
             :src_id,
             :remindable_id,
             :remind_at,
             :done_at,
             :duration,
             :end_date,
             :remindable_type,
             :repeats,
             :end_by,
             :repeat_every,
             :repeat_on,
             :on_type,
             :description,
             :rly_past_due,
             :note,
             :done_occurencies
end

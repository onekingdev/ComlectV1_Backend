# frozen_string_literal: true

class RecurringReminder
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def initialize(src_task, id, date_cursor)
    self.id = id
    self.src_id = src_task.id
    self.body = src_task.body
    self.remindable_id = src_task.remindable_id
    self.remind_at = date_cursor
    self.done_at = nil
    self.duration = src_task.duration
    self.end_date = remind_at + (duration - 1).days
    self.remindable_type = src_task.remindable_type
    self.repeats = src_task.repeats
    self.end_by = src_task.end_by
    self.repeat_every = src_task.repeat_every
    self.repeat_on = src_task.repeat_on
    self.on_type = src_task.on_type
    self.skip_occurencies = src_task.skip_occurencies
    self.done_occurencies = src_task.done_occurencies
    self.rly_past_due = end_date < Time.zone.today.in_time_zone(src_task.remindable.time_zone).to_date
    self.description = src_task.description
    self.note = ''
    self.linkable = src_task.linkable
    self.linkable_id = src_task.linkable_id
    self.linkable_type = src_task.linkable_type
    self.assignee = src_task.assignee
    self.assignee_id = src_task.assignee_id
    self.assignee_type = src_task.assignee_type
    self.messages = nil
    self.created_at = src_task.created_at
    self.updated_at = src_task.updated_at
  end

  attr_accessor :id, :body, :remindable_id, :remind_at, :done_at, :end_date, :remindable_type, :repeats, :rly_past_due,
                :end_by, :repeat_every, :repeat_on, :on_type, :skip_occurencies, :src_id, :duration, :done_occurencies,
                :note, :description, :linkable, :assignee, :messages, :created_at, :updated_at, :linkable_id, :linkable_type,
                :assignee_id, :assignee_type
end

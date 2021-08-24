# frozen_string_literal: true

class Reminder < ActiveRecord::Base
  belongs_to :remindable, polymorphic: true
  belongs_to :linkable, polymorphic: true, optional: true
  belongs_to :assignee, polymorphic: true, optional: true
  has_many :messages, as: :thread

  TOTAL_MONTH = 1..12
  REPEATS = %w[Daily Weekly Monthly Yearly].freeze
  ONTYPES = %w[Day First Second Third Fourth].freeze

  serialize :skip_occurencies
  serialize :done_occurencies

  before_validation :fix_recurring_schedule

  validates :body, presence: true
  validates :remind_at, presence: true
  validates :end_date, presence: true

  validate if: -> { linkable.present? } do
    errors.add :linkable_id, :invalid if linkable.business != remindable
  end

  validate if: -> { assignee.present? } do
    errors.add :assignee_id, :invalid if assignee != remindable && !remindable.team.specialists.include?(assignee)
  end

  def start_time
    remind_at
  end

  def rly_past_due
    end_date < Time.zone.today.in_time_zone(remindable.time_zone).to_date
  end

  def self.week_grid(date)
    date
  end

  def duration
    end_date.mjd - remind_at.mjd + 1
  end

  def self.find_month_day(start_date, on_type, weekday)
    occurence = ONTYPES.index(on_type)
    occurence_i = 1
    weekday = 0 if weekday == 7
    target_date = nil
    (start_date..(start_date + 1.month - 1.day)).each do |date|
      if date.wday == weekday
        if occurence > occurence_i
          occurence_i += 1
        else
          target_date = date
          break
        end
      end
    end
    target_date
  end

  def fix_recurring_schedule
    case repeats
    when 'Daily'
      self.on_type = nil
      self.repeat_on = nil
    when 'Weekly'
      self.on_type = nil
    when 'Monthly'
      self.on_type = 'Day' if on_type.blank?
    when 'Yearly'
      self.on_type = 'Day' if on_type.blank?
    end
    self.end_date = remind_at if remind_at.present? && remind_at > end_date
    self.repeat_every = 1 if repeats.present? && (repeat_every.nil? || repeat_every.zero?)
  end

  def next_occurence(date_cursor)
    case repeats
    when ''
      date_cursor += 100.days
    when 'Daily'
      date_cursor += repeat_every.day
    when 'Weekly'
      sunday_fix = date_cursor.wday
      sunday_fix = 7 if sunday_fix.zero?
      date_cursor -= (sunday_fix - repeat_on).days
      date_cursor += (repeat_every * 7).day
    when 'Monthly'
      date_cursor += repeat_every.months
      date_cursor = date_cursor.beginning_of_month
      date_cursor = if on_type == 'Day'
        date_cursor.change(day: repeat_on)
      else
        Reminder.find_month_day(date_cursor, on_type, repeat_on)
      end
    when 'Yearly'
      date_cursor += 1.year
      date_cursor = date_cursor.change(month: repeat_every)
      date_cursor = date_cursor.beginning_of_month
      date_cursor = if on_type == 'Day'
        date_cursor.change(day: repeat_on)
      else
        Reminder.find_month_day(date_cursor, on_type, repeat_on)
      end
    end
    date_cursor
  end

  def detect_past_dues
    past_dues = []
    occurence_idx = 0
    date_cursor = remind_at
    while date_cursor + (duration - 1).days < Time.zone.today.in_time_zone(remindable.time_zone).to_date
      unless (skip_occurencies.presence || []).include?(occurence_idx) ||
             (done_occurencies.keys.presence || []).include?(occurence_idx)
        past_dues.push([date_cursor, occurence_idx])
      end
      occurence_idx += 1
      date_cursor = next_occurence(date_cursor)
    end
    past_dues
  end

  def detect_all_occurrences(date)
    occurrences = []
    occurrence_idx = 0
    date_cursor = remind_at
    while date_cursor + (duration - 1).days <= date.to_date
      occurrences.push([date_cursor, occurrence_idx]) unless (skip_occurencies.presence || []).include?(occurrence_idx)
      occurrence_idx += 1
      date_cursor = next_occurence(date_cursor)
    end
    occurrences
  end

  def self.get_all_reminders(remindable, tgt_from_date, tgt_to_date, skip_projects)
    data_recurring = []
    reminders = remindable.reminders.where('remind_at > ? AND remind_at < ?', tgt_from_date, tgt_to_date).where(repeats: nil) || []
    recurring_tasks = remindable.reminders.where('remind_at < ?', tgt_to_date).where.not(repeats: nil)
    recurring_tasks.each do |task|
      end_by_date = tgt_to_date
      unless task.end_by.nil?
        end_by_date = task.end_by if task.end_by < tgt_to_date
      end
      occurrences = task.detect_all_occurrences(end_by_date) # [[date, id]...]
      occurrences.each_with_index do |occurrence, i|
        next unless occurrence[0] >= tgt_from_date && occurrence[0] <= tgt_to_date
        sample = RecurringReminder.new(task, "#{task.id}_#{occurrence[1]}", occurrence[0])
        sample.done_at, sample.note = task.done_occurencies[i] if task.done_occurencies.key?(i)
        data_recurring << sample
      end
    end
    projects_complete = []
    projects_active = []
    unless skip_projects
      projects_complete = remindable.projects.complete.where('completed_at > ?', tgt_from_date).where('completed_at < ?', tgt_to_date)
      projects_active = remindable.projects.active.where('starts_on > ?', tgt_from_date).where('starts_on < ?', tgt_to_date)
    end
    (reminders + data_recurring + projects_complete + projects_active).sort_by { |e| e.remind_at.strftime('%Y-%m-%d') }
  end
end

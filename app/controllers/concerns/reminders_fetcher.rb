# frozen_string_literal: true

module RemindersFetcher
  class FakeTask
    def initialize(id)
      self.id = id
    end
    attr_accessor :id
  end

  class RecurringReminder
    def initialize(src_task, id, date_cursor)
      self.id = id
      self.src_id = src_task.id
      self.body = src_task.body
      self.remindable_id = src_task.remindable_id
      self.remind_at = date_cursor
      self.done_at = src_task.done_at
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
    end
    attr_accessor :id, :body, :remindable_id, :remind_at, :done_at, :end_date, :remindable_type, :repeats,
                  :end_by, :repeat_every, :repeat_on, :on_type, :skip_occurencies, :src_id, :duration,
                  :rly_past_due, :done_occurencies
  end

  def tasks_calendar_grid(remindable)
    beginning = params[:start_date] ? Date.parse(params[:start_date]).beginning_of_month : Time.zone.today.beginning_of_month
    end_of_month = beginning + 40.days
    first_day = beginning - beginning.wday.days
    last_day = end_of_month + (6 - end_of_month.wday).days
    @grid_tasks = remindable.reminders.where('end_date >= ? AND remind_at < ?', first_day, last_day).where(repeats: nil)
    @recurring_tasks = remindable.reminders.where('end_by >= ? AND remind_at < ?', first_day, last_day).where.not(repeats: nil)
    @active_projects = remindable.projects.active
    @calendar_grid = {}
    (first_day..last_day).each do |cell|
      @calendar_grid[cell] = []
    end

    @active_projects.each do |task|
      (task.starts_on..task.ends_on).each do |d|
        @calendar_grid[d].push(task) if @calendar_grid.include?(d)
      end
    end

    @grid_tasks.each do |task|
      (task.remind_at..task.end_date).each do |d|
        @calendar_grid[d].push(task) if @calendar_grid.include?(d)
      end
    end

    populate_recurring_tasks(@recurring_tasks, last_day)

    prev_day = nil
    @calendar_grid.keys.each do |date|
      if prev_day.nil?
        prev_day = date
      else
        # fantastic sorting
        safe_arr = []
        additive_arr = []
        @calendar_grid[date].each do |task|
          next unless task.id != 0
          prev_task_index = @calendar_grid[prev_day].collect(&:id).index(task.id)
          !prev_task_index.nil? ? safe_arr[prev_task_index] = task : additive_arr.push(task)
        end
        safe_arr.each_with_index do |a, i|
          safe_arr[i] = additive_arr.shift if a.nil?
        end
        unless additive_arr.empty?
          additive_arr.each do |a|
            safe_arr.push(a)
          end
        end
        safe_arr.each_with_index { |a, i| safe_arr[i] = FakeTask.new(0) if a.nil? }
        @calendar_grid[date] = safe_arr
        prev_day = prev_day.wday == 6 ? nil : date
      end
    end
  end

  def populate_calendar(date_cursor, task, occurence_idx)
    recurring_reminder = RecurringReminder.new(task, "#{task.id}_#{occurence_idx}", date_cursor)
    (date_cursor..(date_cursor + (task.duration - 1).days)).each do |d|
      @calendar_grid[d].push(recurring_reminder) if @calendar_grid.key?(d)
    end
  end

  def populate_recurring_tasks(tasks, last_day)
    tasks.each do |task|
      occurence_idx = 0
      date_cursor = task.remind_at
      while (date_cursor < task.end_by) && (date_cursor < last_day)
        if %w[Daily Weekly Monthly Yearly].include?(task.repeats)
          populate_calendar(date_cursor, task, occurence_idx) unless task.skip_occurencies.include?(occurence_idx)
          occurence_idx += 1
        end
        case task.repeats
        when 'Daily'
          date_cursor += task.repeat_every.day
        when 'Weekly'
          date_cursor += (task.repeat_every * 7).day
        when 'Monthly'
          date_cursor += task.repeat_every.months
          date_cursor = date_cursor.beginning_of_month
          date_cursor = if task.on_type == 'Day'
                          date_cursor.change(day: task.repeat_on)
                        else
                          Reminder.find_month_day(date_cursor, task.on_type, task.repeat_on)
                        end
        when 'Yearly'
          date_cursor += 1.year
          date_cursor = date_cursor.change(month: task.repeat_every)
          date_cursor = date_cursor.beginning_of_month
          date_cursor = if task.on_type == 'Day'
                          date_cursor.change(day: task.repeat_on)
                        else
                          Reminder.find_month_day(date_cursor, task.on_type, task.repeat_on)
                        end
        end
      end
    end
  end

  def reminders_past(remindable)
    recurring_past_dues = []
    remindable.reminders.where.not(repeats: nil).each do |task|
      task.detect_past_dues.each do |d|
        recurring_past_dues.push(RecurringReminder.new(task, "#{task.id}_#{d[1]}", d[0]))
      end
    end

    remindable
      .reminders.where(repeats: nil)
      .where('end_date < ?',
             Time.zone.today.in_time_zone(remindable.time_zone)).where(done_at: nil)
      .order(remind_at: :asc, id: :asc) + recurring_past_dues
  end

  def reminders_today(remindable, calendar_grid)
    today_tasks = []
    calendar_grid.each do |k, v|
      today_tasks = v if k == Time.zone.today.in_time_zone(remindable.time_zone).to_date
    end
    today_tasks
  end

  def reminders_week(remindable, calendar_grid)
    week_tasks = []
    beginning_of_week = Time.zone.today.in_time_zone(remindable.time_zone).beginning_of_week.to_date
    calendar_grid.each do |k, v|
      week_tasks += v if k >= beginning_of_week && k <= beginning_of_week + 6.days
    end
    week_tasks.uniq
  end
end

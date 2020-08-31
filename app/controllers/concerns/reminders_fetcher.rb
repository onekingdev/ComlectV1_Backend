# frozen_string_literal: true

module RemindersFetcher
  class FakeTask
    def initialize(id)
      self.id = id
    end
    attr_accessor :id
  end

  def tasks_calendar_grid(remindable)
    beginning = params[:start_date] ? Date.parse(params[:start_date]).beginning_of_month : Time.zone.today.beginning_of_month
    end_of_month = beginning + 40.days
    first_day = beginning - beginning.wday.days
    last_day = end_of_month + (6 - end_of_month.wday).days
    @grid_tasks = remindable.reminders.where('end_date >= ? AND remind_at < ?', first_day, last_day)
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

    prev_day = nil
    @calendar_grid.keys.each do |date|
      if prev_day.nil?
        prev_day = date
      else
        # weird sorting
        safe_arr = []
        additive_arr = []
        @calendar_grid[date].each do |task|
          next unless task.id != 0
          prev_task_index = @calendar_grid[prev_day].collect(&:id).index(task.id)
          if !prev_task_index.nil?
            safe_arr[prev_task_index] = task
          else
            additive_arr.push(task)
          end
        end
        safe_arr.each_with_index do |a, i|
          safe_arr[i] = additive_arr.shift if a.nil?
        end
        unless additive_arr.empty?
          additive_arr.each do |a|
            safe_arr.push(a)
          end
        end
        safe_arr.each_with_index do |a, i|
          safe_arr[i] = FakeTask.new(0) if a.nil?
        end
        @calendar_grid[date] = safe_arr
        prev_day = if prev_day.wday == 6
                     nil
                   else
                     date
                   end
      end
    end
  end

  def reminders_past(remindable)
    remindable
      .reminders
      .where('end_date < ?',
             Time.zone.today.in_time_zone(remindable.time_zone)).where(done_at: nil)
      .order(remind_at: :asc, id: :asc)
  end

  def reminders_today(remindable)
    remindable
      .reminders
      .where('remind_at <= ? AND end_date >= ?',
             Time.zone.today.in_time_zone(remindable.time_zone),
             Time.zone.today.in_time_zone(remindable.time_zone))
      .order(remind_at: :asc, id: :asc) +
      remindable.projects.active.where('starts_on <= ?',
                                       Time.zone.today.in_time_zone(remindable.time_zone))
  end

  def reminders_week(remindable)
    remindable
      .reminders
      .where('end_date >= ? AND remind_at <= ?',
             Time.zone.today.beginning_of_week.in_time_zone(remindable.time_zone),
             Time.zone.today.end_of_week.in_time_zone(remindable.time_zone))
      .order(remind_at: :asc, id: :asc) +
      remindable.projects.active.where('starts_on <= ?',
                                       Time.zone.today.in_time_zone(remindable.time_zone))
  end
end

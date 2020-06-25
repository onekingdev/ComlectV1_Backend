# frozen_string_literal: true

class FakeTask
  def initialize(id)
    self.id = id
  end
  attr_accessor :id
end

class BusinessDashboardController < ApplicationController
  include BusinessDashboard

  before_action :require_business!
  before_action :business_payment_profile?
  before_action :beginning_of_week
  before_action :init_tasks_calendar_grid

  def show
    @business = current_user.business
    @business.spawn_compliance_policies
    @financials = Business::Financials.for(current_business)
    @ratings = @business.ratings_received.preload_associations
    @reminders_today = reminders_today
    @reminders_week = reminders_week
    @reminders_past = reminders_past
    @current_year_annual_review = @business.processed_annual_reviews.where(year: Time.zone.today.year)
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def business_payment_profile?
    redirect_to '/business/onboarding' if current_business && !current_business.onboarding_passed
  end

  # def tasks_calendar_grid
  #   beginning = params[:start_date] ? Date.parse(params[:start_date]).beginning_of_month : Time.zone.today.beginning_of_month
  #   end_of_month = beginning + 40.days
  #   first_day = beginning - beginning.wday.days
  #   last_day = end_of_month + (6 - end_of_month.wday).days
  #   @grid_tasks = current_business.reminders.where('end_date >= ? AND remind_at < ?', first_day, last_day)
  #   @active_projects = current_business.projects.active
  #   @calendar_grid = {}
  #   (first_day..last_day).each do |cell|
  #     @calendar_grid[cell] = []
  #   end
  #
  #   @active_projects.each do |task|
  #     (task.starts_on..task.ends_on).each do |d|
  #       @calendar_grid[d].push(task) if @calendar_grid.include?(d)
  #     end
  #   end
  #
  #   @grid_tasks.each do |task|
  #     (task.remind_at..task.end_date).each do |d|
  #       @calendar_grid[d].push(task) if @calendar_grid.include?(d)
  #     end
  #   end
  #
  #   prev_day = nil
  #   @calendar_grid.keys.each do |date|
  #     if prev_day.nil?
  #       prev_day = date
  #     else
  #       # weird sorting
  #       safe_arr = []
  #       additive_arr = []
  #       @calendar_grid[date].each do |task|
  #         next unless task.id != 0
  #         prev_task_index = @calendar_grid[prev_day].collect(&:id).index(task.id)
  #         if !prev_task_index.nil?
  #           safe_arr[prev_task_index] = task
  #         else
  #           additive_arr.push(task)
  #         end
  #       end
  #       safe_arr.each_with_index do |a, i|
  #         safe_arr[i] = additive_arr.shift if a.nil?
  #       end
  #       unless additive_arr.empty?
  #         additive_arr.each do |a|
  #           safe_arr.push(a)
  #         end
  #       end
  #       safe_arr.each_with_index do |a, i|
  #         safe_arr[i] = FakeTask.new(0) if a.nil?
  #       end
  #       @calendar_grid[date] = safe_arr
  #       prev_day = if prev_day.wday == 5
  #                    nil
  #                  else
  #                    date
  #                  end
  #     end
  #   end
  # end

  def init_tasks_calendar_grid
    tasks_calendar_grid
  end
end

# frozen_string_literal: true

class Specialists::DashboardController < ApplicationController
  include RemindersFetcher
  include ChartData

  before_action :authenticate_user!
  before_action :require_specialist!
  before_action :beginning_of_week
  before_action :init_tasks_calendar_grid

  def show
    @specialist = Specialist.preload_associations.find(current_user.specialist.id)
    @financials = Specialist::Financials.for(current_specialist)
    @reminders_today = reminders_today(current_specialist)
    @reminders_week = reminders_week(current_specialist)
    @reminders_past = reminders_past(current_specialist)
    @compliance_spend = ['Earned'] + transactions_monthly(@specialist)
  end

  def locked
    redirect_to specialists_dashboard_path if current_specialist.dashboard_unlocked
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def init_tasks_calendar_grid
    tasks_calendar_grid(current_specialist)
  end
end

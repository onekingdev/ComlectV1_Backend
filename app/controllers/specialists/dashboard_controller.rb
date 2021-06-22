# frozen_string_literal: true

class Specialists::DashboardController < ApplicationController
  include ActionView::Helpers::TagHelper

  include RemindersFetcher
  include ChartData

  before_action :authenticate_user!
  before_action :require_specialist!
  before_action :beginning_of_week
  before_action :init_tasks_calendar_grid

  def show
   # @specialist = Specialist.preload_association.find(current_user.specialist.id)
   # @financials = Specialist::Financials.for(current_specialist)
   # @reminders_today = reminders_today(current_specialist, @calendar_grid)
   # @reminders_week = reminders_week(current_specialist, @calendar_grid)
   # @reminders_past = reminders_past(current_specialist)
   # @calendar_grid = tasks_calendar_grid(current_specialist, Date.parse(params[:start_date]).beginning_of_month) if params[:start_date]
   # @compliance_spend = ['Earned'] + transactions_monthly(@specialist)

   render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end

  def locked
    redirect_to specialists_dashboard_path if current_specialist.dashboard_unlocked
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :monday
  end

  def init_tasks_calendar_grid
    @calendar_grid = tasks_calendar_grid(current_specialist, Time.zone.today.beginning_of_month)
  end
end

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
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_specialist_layout'
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

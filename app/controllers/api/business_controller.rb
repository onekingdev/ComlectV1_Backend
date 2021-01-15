# frozen_string_literal: true

class Api::BusinessController < ApplicationController
  include RemindersFetcher

  before_action :authenticate_user!, only: %i[index]
  before_action :require_business!, only: %i[index]

  def index
    tasks, projects = tasks_calendar_grid2(current_business, Date.parse(params[:date_from]), Date.parse(params[:date_to]))
    render json: { tasks: tasks, projects: projects }
  end
end

# frozen_string_literal: true

class Specialists::QuestionsController < ApplicationController
  before_action :require_specialist!

  def show
    @user = current_user
    render 'business/questions/show'
  end
end

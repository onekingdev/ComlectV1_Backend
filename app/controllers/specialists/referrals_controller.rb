# frozen_string_literal: true

class Specialists::ReferralsController < ApplicationController
  before_action :require_specialist!

  def show
    @specialist = current_specialist
  end
end

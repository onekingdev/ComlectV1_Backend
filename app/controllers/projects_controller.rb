# frozen_string_literal: true
class Business::ProjectsController < ApplicationController
  before_action :authenticate_user!
end

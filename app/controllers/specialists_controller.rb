# frozen_string_literal: true
class SpecialistsController < ApplicationController
  before_action -> do
    redirect_to specialist_path(current_user.specialist)
  end, if: -> { user_signed_in? && current_user.specialist }, only: %i(new create)

  before_action :authenticate_user!, only: %i(edit update)
  before_action :require_specialist!, only: %i(edit update)
  before_action :require_business!, only: %i(index)

  def index
    @search = Specialist::Search.new(search_params)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @specialist = Specialist.preload_associations.find(params[:id])
  end

  def new
    @specialist = Specialist::Form.signup
  end

  def create
    @specialist = Specialist::Form.signup(specialist_params)
    if @specialist.save
      sign_in @specialist.user
      return redirect_to specialists_dashboard_path
    end
    render :new
  end

  def edit
    @specialist = Specialist::Form.for_user(current_user)
  end

  def update
    @specialist = Specialist::Form.for_user(current_user)
    respond_to do |format|
      if @specialist.update_attributes(edit_specialist_params)
        format.html { return redirect_to_param_or specialists_dashboard_path }
        format.js { render nothing: true, status: :ok }
      else
        format.html { render :edit }
        format.js { js_alert('Could not save your changes, please try again later.') }
      end
    end
  end

  private

  def specialist_params
    params.require(:specialist).permit(
      :first_name, :last_name, :country, :state, :city, :zipcode, :lat, :lng, :phone, :linkedin_link, :public_profile,
      :former_regulator, :certifications, :photo, :resume, :time_zone,
      jurisdiction_ids: [], industry_ids: [], skill_names: [],
      user_attributes: %i(email password),
      work_experiences_attributes: %i(id company job_title location from to current compliance description _destroy),
      education_histories_attributes: %i(id institution degree year _destroy)
    )
  end

  def edit_specialist_params
    specialist_params.except(:user_attributes)
  end

  def search_params
    specialist_search_params = params[:specialist_search]
    return params.slice(:page) unless specialist_search_params
    permitted = specialist_search_params.permit(
      :sort_by, :keyword, :rating, :experience, :regulator, :location, :location_range, :lat, :lng, :page,
      industry_ids: [], jurisdiction_ids: []
    )
    permitted.merge!(params.slice(:page)) if permitted[:page].blank? || params[:page].to_i > 0
    permitted
  end
end

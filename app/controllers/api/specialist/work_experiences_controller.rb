# frozen_string_literal: true

class Api::Specialist::WorkExperiencesController < ApiController
  before_action :require_specialist!
  before_action :find_experience, only: %i[update destroy]
  skip_before_action :verify_authenticity_token

  def index
    respond_with current_specialist.work_experiences, each_serializer: WorkExperienceSerializer
  end

  def create
    experience = current_specialist.work_experiences.create(experience_params)
    if experience.persisted?
      respond_with experience, serializer: WorkExperienceSerializer
    else
      respond_with experience
    end
  end

  def update
    if @experience.update(experience_params)
      respond_with @experience, serializer: WorkExperienceSerializer
    else
      respond_with @experience
    end
  end

  def destroy
    if @experience.destroy
      respond_with status: :ok
    else
      respond_with @experience
    end
  end

  private

  def find_experience
    @experience = current_specialist.work_experiences.find(params[:id])
  end

  def experience_params
    params.require(:work_experience).permit(:id, :company, :job_title, :start_date, :end_date, :current, :description)
  end
end

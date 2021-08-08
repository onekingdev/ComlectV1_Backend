# frozen_string_literal: true

class Api::SpecialistsController < ApiController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :require_someone!, only: :update

  def create
    specialist = Specialist.new(specialist_params)

    if specialist.save
      BusinessMailer.verify_email(specialist.user, specialist.user.otp).deliver_later
      render json: { userid: specialist.user_id, message: I18n.t('api.specialists.confirm_otp') }.to_json
    else
      respond_with errors: { specialist: specialist.errors.messages }
    end
  end

  def update
    specialist = current_specialist
    if specialist.update(edit_specialist_params)
      specialist.username = specialist.generate_username if specialist.username.blank?
      specialist.update(sub_industries: convert_sub_industries(params[:sub_industry_ids])) if params[:sub_industry_ids].present?
      set_skills
      respond_with specialist, serializer: ::SpecialistSerializer
    else
      respond_with errors: { specialist: specialist.errors.messages }
    end
  end

  private

  def convert_sub_industries(ids)
    return [] if ids.blank?
    tgt_industries = []
    ids.each do |sub_ind|
      c = sub_ind.split('_').map(&:to_i)
      if current_specialist.industries.collect(&:id).include? c[0]
        tgt_industries.push(Industry.find(c[0]).sub_industries_specialist.split("\r\n")[c[1]])
      end
    end
    tgt_industries
  end

  def set_skills
    skill_names = params[:skill_names]
    return if skill_names.empty?

    skills = skill_names.map do |skill_name|
      Skill.find_or_create_by(name: skill_name)
    end
    current_specialist.skills = skills
  end

  def specialist_params
    params.require(:specialist).permit(
      :first_name, :last_name,
      :former_regulator, :certifications, :resume,
      :experience, :specialist_other,
      jurisdiction_ids: [], industry_ids: [],
      user_attributes: %i[
        email password
      ]
    )
  end

  def edit_specialist_params
    specialist_params.except(:user_attributes)
  end
end

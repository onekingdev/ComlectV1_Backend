# frozen_string_literal: true

class Business::OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!
  # rubocop:disable all

  def index
    @pos_total = 0
    if params[:onboarding].present? && params[:onboarding][:business_stages].present?
      if I18n.t(:business_products).keys.map(&:to_s).include?(params[:onboarding][:business_stages])
        current_business.update(business_stages: params[:onboarding][:business_stages])
      end
    end
    if %w[registration registration_and_maintenance].include?(current_business.business_stages)
      @product = ProjectTemplate.find_by(identifier: current_business.business_stages)
    end
    @subscription = %w[registration_and_maintenance compliance_command_center].include?(current_business.business_stages)

    if params['complete'].present? && current_business.can_unlock_dashboard?
      if @product.present?
        @project = create_project
        if @project.save!
          current_business.update(onboarding_passed: true)
          current_business.update(ria_dashboard: true) if @subscription.present?
          redirect_to business_project_path(@project)
        else
          redirect_to '/business/onboarding?error=1'
        end
      else
        current_business.update(onboarding_passed: true)
        current_business.update(ria_dashboard: true) if @subscription.present?
        redirect_to business_dashboard_path
      end
    else
      @sources = current_business.payment_sources.sorted
      @pos_total += @product.fixed_budget.to_i if @product
      @pos_total_annual = @pos_total
      @pos_total_annual += 1500 if @subscription
      @pos_total += 600 if @subscription
    end
  end
  # rubocop:enable all

  private

  def create_project
    Project.new.build_from_template(current_business.id, @product, {})
  end
end

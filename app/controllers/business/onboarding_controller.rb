# frozen_string_literal: true

class Business::OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!
  before_action :assign_product, only: ['subscribe']

  include SubscriptionHelper

  def index
    @pos_total = 0
    @product = find_product
    @sources = current_business.payment_sources.sorted
    @pos_total += @product.fixed_budget.to_i if @product
    @pos_total_annual = @pos_total
    @pos_total_annual += 1500 if need_subscription?
    @pos_total += 600 if need_subscription?
  end

  def subscribe # rubocop:disable Metrics/AbcSize
    stripe_customer = current_business.payment_profile.stripe_customer
    return redirect_to '/business/onboarding', flash: { error: 'No customer' } unless stripe_customer
    @product = find_product

    if current_business.base_subscribed?
      mark_passed
      return redirect_to business_dashboard_path, flash: { success: 'Already subscribed' }
    end

    plan = params[:checkout][:schedule].to_s.downcase.strip rescue nil
    return redirect_to '/business/onboarding', flash: { error: 'Wrong plan' } unless Subscription.plans.key?(plan)

    db_subscription = current_business.subscription || Subscription.create(plan: plan, business_id: current_business.id)

    if db_subscription&.stripe_invoice_item_id.blank?
      one_time_item = Subscription.create_invoice_item(stripe_customer)
      db_subscription.update(stripe_invoice_item_id: one_time_item.id)
    end

    if db_subscription&.stripe_subscription_id.blank?
      sub = Subscription.subscribe(plan, stripe_customer)
      db_subscription.update(stripe_subscription_id: sub.id)
    end

    project = nil
    if @product.present?
      project = create_project

      return redirect_to '/business/onboarding', flash: { error: project.errors&.full_messages&.first } unless project.save
    end

    mark_passed

    redirect_to project ? business_project_path(project) : business_dashboard_path
  rescue => e
    redirect_to business_onboarding_path, flash: { error: (e.message if e.class.name != 'NoMethodError') }
  end

  private

  def create_project
    Project.new.build_from_template(current_business.id, @product, {})
  end

  def find_product
    identifier = if I18n.t(:business_products).keys.map(&:to_s).include?(current_business.business_stages)
                   current_business.business_stages
                 end
    return unless identifier

    ProjectTemplate.find_by(identifier: identifier)
  end

  def assign_product
    # rubocop:disable Style/GuardClause
    if params[:onboarding].present? && params[:onboarding][:business_stages].present?
      if I18n.t(:business_products).keys.map(&:to_s).include?(params[:onboarding][:business_stages])
        current_business.update(business_stages: params[:onboarding][:business_stages])
      end
    end
    # rubocop:enable Style/GuardClause
  end

  def mark_passed
    current_business.update(onboarding_passed: true)
    current_business.update(ria_dashboard: true) if need_subscription?
  end
end

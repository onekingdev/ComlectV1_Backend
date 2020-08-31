# frozen_string_literal: true

class Business::OnboardingController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!
  before_action :go_to_dashboard, only: :subscribe
  before_action :assign_product, only: :subscribe
  before_action :render_index, only: :subscribe

  include SubscriptionHelper
  include SubscriptionCommon

  def index
    return redirect_to business_dashboard_path if current_business.onboarding_passed

    @pos_total = 0
    @product = find_product
    @sources = current_business.payment_sources.sorted
    @pos_total += @product.fixed_budget.to_i if @product
    @pos_total_annual = @pos_total
    @pos_total_annual += 1500 if need_subscription?
    @pos_total += 600 if need_subscription?
  end

  def subscribe
    stripe_customer = current_business.payment_profile.stripe_customer
    return redirect_to '/business/onboarding', flash: { error: 'No customer' } unless stripe_customer

    @product = find_product

    if current_business.base_subscribed?
      mark_passed
      return redirect_to business_dashboard_path, flash: { success: 'Already subscribed' }
    end

    if need_subscription?
      plan = params[:checkout][:schedule].to_s.downcase.strip rescue nil
      return redirect_to '/business/onboarding', flash: { error: 'Wrong plan' } unless Subscription.plans.key?(plan)

      db_subscription = current_business.subscriptions.base.presence || Subscription.create(
        plan: plan,
        business_id: current_business.id,
        title: 'Compliance Command Center',
        payment_source: current_business.payment_profile.default_payment_source
      )

      add_one_time_payment(db_subscription)

      if db_subscription&.stripe_subscription_id.blank?
        sub = Subscription.subscribe(
          plan,
          stripe_customer,
          current_business.payment_profile.default_payment_source.coupon_id,
          period_ends: (Time.now.utc + 1.year).to_i
        )
        db_subscription.update(
          stripe_subscription_id: sub.id,
          billing_period_ends: sub.created
        )
      end
    end

    project = nil

    if need_product? && @product.present?
      project = create_project

      return redirect_to '/business/onboarding', flash: { error: project.errors&.full_messages&.first } unless project.save
    end

    mark_passed

    redirect_to business_dashboard_path
  rescue => e
    redirect_to business_onboarding_path, flash: { error: (e.message if e.class.name != 'NoMethodError') }
  end

  private

  def create_project
    Project.new.build_from_template(current_business.id, @product, {})
  end

  def find_product
    return unless products?

    identifier = current_business.business_stages
    return unless identifier

    ProjectTemplate.find_by(identifier: identifier)
  end

  def assign_product
    return unless params[:onboarding].present? && params[:onboarding][:business_stages].present?

    return unless products?(params[:onboarding][:business_stages])

    current_business.update(business_stages: params[:onboarding][:business_stages])
  end

  def mark_passed
    current_business.update(onboarding_passed: true)
    current_business.update(ria_dashboard: true) if need_subscription?
    BusinessMailer.welcome(Business.find(current_business.id)).deliver_later
  end

  def go_to_dashboard
    return if (current_business.ria? && need_subscription?) || current_business.payment_sources.blank?

    return if need_product? && @product.blank?

    mark_passed
    redirect_to(business_dashboard_path)
  end

  def products?(keys = nil)
    I18n.t(:business_products).stringify_keys.key?(keys || current_business.business_stages)
  end

  def render_index
    render :index if !current_business.onboarding_passed && need_subscription? && params[:checkout].blank?
  end
end

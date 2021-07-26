# frozen_string_literal: true

class StripeBusinessSubscriptionService < BaseBusinessSubscriptionService
  # Business plans:
  # 1 => 'free'
  # 2 => 'team_tier_monthly'
  # 3 => 'team_tier_annual'
  # 4 => 'business_tier_monthly'
  # 5 => 'business_tier_annual'

  def call
    begin
      return self if plan_name_invalid?
      return self if free_plan? && subscribe_free_plan
      return self if payment_source_missing?

      return self if active_subscriptions.blank? && create_new_subscriptions
      return self if nothing_to_change?
      return self if only_seat_count_change? && update_seats

      __send__("#{action_name}_#{current_plan}_to_#{new_plan}")
      onboarding_passed!
    rescue Stripe::StripeError => e
      handle_stripe_error(e.message)
    end

    self
  end

  private

  # UPGRADE ACTIONS

  # Team Monthly (Jul 12) => Team Annual (Sep 25)
  # User billed $150/mo Jul 12, Aug 12, Sep 12
  # On Sep 25, user is charged $1500 and one year contract date is set to Sep 25
  # Every year on Sep 25 it will automatically charge $1500 until they cancel/edit
  def upgrade_team_tier_monthly_to_team_tier_annual
    upgrade_subscription
  end

  # Team Monthly (Jul 12) => Business Monthly (Sep 25)
  # User billed $150/mo Jul 12, Aug 12, Sep 12
  # On Sep 25, user is charged $250/mo. and new monthly contract date set for Sep 25
  def upgrade_team_tier_monthly_to_business_tier_monthly
    upgrade_to_new_plan
  end

  # Team Monthly (Jul 12) => Business Annual (Sep 25)
  # User billed $150/mo Jul 12, Aug 12, Sep 12
  # On Sep 25, user is charged $2520 and one year contract date is set to Sep 25
  # Every year on Sep 25 it will automatically charge $2520 until they cancel/edit.
  def upgrade_team_tier_monthly_to_business_tier_annual
    upgrade_to_new_plan
  end

  # Team Annual -> Business Monthly
  # Jul 12 - $1500, Sep 25 - cancel team annual and charge $250
  def upgrade_team_tier_annual_to_business_tier_monthly
    upgrade_to_new_plan
  end

  # Team Annual => Business Annual
  # Jul 12 - $1500, Sep 25 - cancel team annual and charge $2,520
  def upgrade_team_tier_annual_to_business_tier_annual
    upgrade_to_new_plan
  end

  # Business Monthly (Jul 12) => Business Annual (Sep 25)
  # User billed $250/mo Jul 12, Aug 12, Sep 12
  # On Sep 25, user is charged $2520 and one year contract date is set to Sep 25
  # Every year on Sep 25 it will automatically charge $2520 until they cancel/edit.
  def upgrade_business_tier_monthly_to_business_tier_annual
    upgrade_subscription
  end

  # DOWNGRADE ACTIONS

  def downgrade_business_tier_annual_to_business_tier_monthly
    downgrade_to_new_plan_with_refund
  end

  # Business Annual (Jul 12) => Team Annual (Sep 25)
  # User is charged $2520 on Jul 12
  # On Sep 25, user is refunded for prorated days of use between Jul 12 and Sep 25
  # Business annual is cancelled Sep 25 and Team Annual contract begins Sep 25
  # Annually renews every Sep 25
  def downgrade_business_tier_annual_to_team_tier_annual
    downgrade_to_new_plan_with_refund
  end

  # Business Annual (Jul 12) => Team Monthly (Sep 25)
  # User is charged $2520 on Jul 12
  # On Sep 25, user is refunded for prorated days of use between Jul 12 and Sep 25
  # Business annual is cancelled Sep 25
  # and user is charged $250/mo on Sep 25 and every 25 day of month until they cancel
  def downgrade_business_tier_annual_to_team_tier_monthly
    downgrade_to_new_plan_with_refund
  end

  # Business Monthly (Jul 12) => Team Annual (Sep 25)
  # User is charged $250/mo on Jul 12, Aug 12, Sep 12
  # On Sep 25, user is charged $1500 and annual contract date set for Sep 25
  # and recur every year on Sep 25 until cancel/edit
  def downgrade_business_tier_monthly_to_team_tier_annual
    downgrade_subscription
  end

  # Business Monthly (Jul 12) => Team Monthly (Sep 25)
  # User is charged $250/mo on Jul 12, Aug 12, Sep 12
  # On Sep 25, user is charged $150/mo and new monthly contract date set for Sep 25.
  def downgrade_business_tier_monthly_to_team_tier_monthly
    downgrade_subscription
  end

  # Team Annual (Jul 12) => Team Monthly (Sep 25)
  # User billed $1500 Jul 12
  # On Sep 25, user refunded for prorated days of use between Jul 12 and Sep 25th
  # Annual contract cancelled.
  # Monthly billing $150/mo on Sep 25, Oct 25, Nov 25, etc. until monthly plan is cancelled.
  def downgrade_team_tier_annual_to_team_tier_monthly
    downgrade_to_new_plan_with_refund
  end
end

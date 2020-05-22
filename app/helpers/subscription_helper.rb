# frozen_string_literal: true

module SubscriptionHelper
  def need_subscription?
    %w[registration_and_maintenance compliance_command_center].include?(current_business&.business_stages)
  end
end

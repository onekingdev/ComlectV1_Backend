# frozen_string_literal: true

class BusinessDashboardController < ApplicationController
  include RemindersFetcher
  include ChartData
  include ActionView::Helpers::TagHelper

  before_action :require_business!
  before_action :business_payment_profile?
  before_action :beginning_of_week

  def show
    render html: content_tag('main-layoyt', '').html_safe, layout: 'vue_main_layout'
  end

  private

  def beginning_of_week
    Date.beginning_of_week = :monday
  end

  def business_payment_profile?
    redirect_to '/business/onboarding' if current_business && !current_business.onboarding_passed
  end
end

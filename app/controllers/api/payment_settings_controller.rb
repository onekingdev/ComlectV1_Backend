# frozen_string_literal: true

class Api::PaymentSettingsController < ApiController
  before_action :require_someone!

  def apply_coupon
    if params[:coupon].present? && load_coupon
      render json: {
        coupon_id: @coupon.id,
        percent_off: @coupon.percent_off,
        message: 'Coupon code applied successfully.'
      }, status: :ok
    else
      render json: {
        errors: { message: 'Entered Coupon code is not valid.' }
      }, status: :unprocessable_entity
    end
  end

  private

  def load_coupon
    @coupon = found_in_coupons
    @coupon ||= found_in_promotions
  end

  def found_in_coupons
    Stripe::Coupon.retrieve(params[:coupon])
  rescue
    false
  end

  def found_in_promotions
    Stripe::PromotionCode.list(limit: 100).auto_paging_each do |promo|
      return promo.coupon if promo.code == params[:coupon]
    end

    false
  end
end

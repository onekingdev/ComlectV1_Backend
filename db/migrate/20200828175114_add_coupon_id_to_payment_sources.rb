# frozen_string_literal: true

class AddCouponIdToPaymentSources < ActiveRecord::Migration
  def change
    add_column :payment_sources, :coupon_id, :string
  end
end

# frozen_string_literal: true

class AddCouponIdToPaymentSources < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_sources, :coupon_id, :string unless ActiveRecord::Base.connection.column_exists?(:payment_sources, :coupon_id)
  end
end

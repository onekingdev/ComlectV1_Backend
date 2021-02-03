# frozen_string_literal: true

class AllowNullOnPaymentSourcesColumns < ActiveRecord::Migration
  def change
    change_column_null :payment_sources, :exp_month, true
    change_column_null :payment_sources, :exp_year, true
  end
end

# frozen_string_literal: true

class UpdateFinancialsForecastedView < ActiveRecord::Migration[6.0]
  def change
    replace_view :financials_forecasted, version: 4, revert_to_version: 3
  end
end

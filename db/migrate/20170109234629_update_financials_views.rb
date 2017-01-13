# frozen_string_literal: true
class UpdateFinancialsViews < ActiveRecord::Migration
  def change
    replace_view :financials_actual, version: 2, revert_to_version: 1
    replace_view :financials_forecasted, version: 2, revert_to_version: 1
    replace_view :financials_postings, version: 2, revert_to_version: 1
  end
end

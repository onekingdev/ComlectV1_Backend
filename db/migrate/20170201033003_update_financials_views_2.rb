# frozen_string_literal: true

class UpdateFinancialsViews2 < ActiveRecord::Migration
  def change
    drop_view :financials
    update_view :financials_forecasted, version: 5, revert_to_version: 4
    update_view :financials_postings, version: 3, revert_to_version: 2
    create_view :financials
  end
end

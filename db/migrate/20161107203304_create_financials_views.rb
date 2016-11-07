# frozen_string_literal: true
class CreateFinancialsViews < ActiveRecord::Migration
  def change
    create_view :financials_actual
    create_view :financials_forecasted
    create_view :financials_postings
    create_view :financials
  end
end

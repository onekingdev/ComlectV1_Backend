# frozen_string_literal: true

class AddsBillDateToForumSubscriptions < ActiveRecord::Migration
  def change
    add_column :forum_subscriptions, :annual_bill_date, :string
    add_column :forum_subscriptions, :monthly_bill_date, :string
  end
end

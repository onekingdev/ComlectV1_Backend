# frozen_string_literal: true

class AddsRenewalDateToForumSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :forum_subscriptions, :renewal_date, :datetime
  end
end

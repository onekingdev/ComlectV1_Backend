# frozen_string_literal: true
class AddTosFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tos_acceptance_date, :datetime
    add_column :users, :tos_acceptance_ip, :string
  end
end

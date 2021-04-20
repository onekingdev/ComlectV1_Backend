# frozen_string_literal: true

class AddEmailConfirmedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_confirmed, :boolean, default: false

    User.all.each { |user| user.update(email_confirmed: true) }
  end
end

# frozen_string_literal: true

class AddOtpToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :otp_secret, :string
    add_column :users, :otp_counter, :integer
  end
end

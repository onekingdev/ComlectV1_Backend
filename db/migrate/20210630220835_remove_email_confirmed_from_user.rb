# frozen_string_literal: true

class RemoveEmailConfirmedFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :email_confirmed, :boolean
  end
end

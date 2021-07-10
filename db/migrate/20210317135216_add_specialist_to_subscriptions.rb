# frozen_string_literal: true

class AddSpecialistToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :subscriptions, :specialist, null: true, foreign_key: true
  end
end

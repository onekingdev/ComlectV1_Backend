# frozen_string_literal: true

class CreateFeedbackRequests < ActiveRecord::Migration
  def change
    create_table :feedback_requests do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :specialists
      t.string :budget
      t.text :description
      t.inet :ip
      t.string :user_agent
      t.string :kind

      t.timestamps null: false
    end
  end
end

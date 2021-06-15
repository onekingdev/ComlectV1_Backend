# frozen_string_literal: true

class CreateExamAuditors < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_auditors do |t|
      t.integer :exam_id
      t.string :email
      t.integer :otp
      t.datetime :otp_requested

      t.timestamps
    end
  end
end

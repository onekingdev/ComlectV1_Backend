# frozen_string_literal: true

class ChangeIntegerOtpToString < ActiveRecord::Migration[6.0]
  def change
    change_column :exam_auditors, :otp, :string
  end
end

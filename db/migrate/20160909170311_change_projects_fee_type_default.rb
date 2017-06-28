# frozen_string_literal: true

class ChangeProjectsFeeTypeDefault < ActiveRecord::Migration
  def change
    change_column_default :projects, :fee_type, 'upfront_fee'
    reversible do |dir|
      dir.up do
        Project.where(fee_type: 'upfront').update_all fee_type: 'upfront_fee'
        Project.where(fee_type: 'monthly').update_all fee_type: 'monthly_fee'
      end
      dir.down do
        Project.where(fee_type: 'upfront_fee').update_all fee_type: 'upfront'
        Project.where(fee_type: 'monthly_fee').update_all fee_type: 'monthly'
      end
    end
  end
end

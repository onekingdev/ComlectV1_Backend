class AddTrialEndToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :trial_end, :datetime
  end
end

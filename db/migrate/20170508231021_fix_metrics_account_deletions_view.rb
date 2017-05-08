# frozen_string_literal: true
class FixMetricsAccountDeletionsView < ActiveRecord::Migration
  def change
    replace_view :metrics_account_deletions, version: 2, revert_to_version: 1
  end
end

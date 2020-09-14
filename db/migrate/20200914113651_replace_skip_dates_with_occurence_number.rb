# frozen_string_literal: true

class ReplaceSkipDatesWithOccurenceNumber < ActiveRecord::Migration
  def change
    rename_column :reminders, :skip_dates, :skip_occurencies
  end
end

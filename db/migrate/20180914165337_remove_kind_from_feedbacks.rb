# frozen_string_literal: true

class RemoveKindFromFeedbacks < ActiveRecord::Migration
  def change
    remove_column :feedback_requests, :kind
  end
end

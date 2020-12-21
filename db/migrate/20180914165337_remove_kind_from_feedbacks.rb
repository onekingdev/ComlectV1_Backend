# frozen_string_literal: true

class RemoveKindFromFeedbacks < ActiveRecord::Migration[6.0]
  def change
    remove_column :feedback_requests, :kind
  end
end

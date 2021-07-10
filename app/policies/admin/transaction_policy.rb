# frozen_string_literal: true

class Admin::TransactionPolicy < AdminPolicy
  def process_pending?
    true
  end
end

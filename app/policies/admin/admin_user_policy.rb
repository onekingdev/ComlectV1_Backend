# frozen_string_literal: true

class Admin::AdminUserPolicy < AdminPolicy
  def toggle_suspend?
    true
  end
end

# frozen_string_literal: true
class Admin::BusinessPolicy < AdminPolicy
  def toggle_suspend?
    true
  end
end

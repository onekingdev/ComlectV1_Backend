# frozen_string_literal: true
class Admin::ProjectPolicy < AdminPolicy
  def reschedule_charges?
    true
  end

  def end?
    true
  end
end

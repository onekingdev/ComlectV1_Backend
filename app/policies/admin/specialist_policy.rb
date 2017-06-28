# frozen_string_literal: true

class Admin::SpecialistPolicy < AdminPolicy
  def toggle_suspend?
    true
  end
end

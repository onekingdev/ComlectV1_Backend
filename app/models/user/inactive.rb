# frozen_string_literal: true

class User::Inactive
  def self.process!(user)
    user.update(inactive_for_period: true)
  end
end

# frozen_string_literal: true
class User::Decorator < Draper::Decorator
  decorates User
  delegate_all

  def to_s
    business ? business.business_name : "Specialist"
  end
end

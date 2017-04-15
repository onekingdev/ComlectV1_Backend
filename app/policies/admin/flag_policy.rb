# frozen_string_literal: true
class Admin::FlagPolicy < AdminPolicy
  def send_email_to_offending_users?
    true
  end
end

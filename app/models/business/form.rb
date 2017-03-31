# frozen_string_literal: true
class Business::Form < Business
  include ApplicationForm

  def self.for_user(user)
    where(user_id: user.id).first!
  end

  def save(*)
    sync_triggered = (%w(anonymous business_name logo_data) & changed).any?
    super.tap do |result|
      discourse.sync if result && sync_triggered
    end
  end

  def discourse
    @_discourse ||= Business::Discourse.new(self)
  end
end

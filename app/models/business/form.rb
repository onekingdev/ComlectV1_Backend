# frozen_string_literal: true

class Business::Form < Business
  include ApplicationForm

  before_save :destroy_logo?
  attr_writer :delete_logo

  def self.for_user(user)
    where(user_id: user.id).first!
  end

  def save(*)
    sync_triggered = (%w[anonymous business_name logo_data] & changed).any?
    super.tap do |result|
      discourse.sync if result && sync_triggered
    end
  end

  def discourse
    @_discourse ||= Business::Discourse.new(self)
  end

  def delete_logo
    @delete_logo ||= "0"
  end

  private

  def destroy_logo?
    self.logo = nil if @delete_logo == "1"
  end
end

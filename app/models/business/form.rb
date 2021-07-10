# frozen_string_literal: true

class Business::Form < Business
  include ApplicationForm

  before_save :destroy_logo?
  attr_writer :delete_logo

  def self.for_user(user)
    where(user_id: user.id).first!
  end

  def delete_logo
    @delete_logo ||= '0'
  end

  private

  def destroy_logo?
    self.logo = nil if @delete_logo == '1'
  end
end

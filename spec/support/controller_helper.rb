# frozen_string_literal: true

module ControllerHelper
  def login_as_business(user = nil)
    user = FactoryBot.create(:business).user if user.blank?
    login_user(user)
  end

  def login_as_specialist(user = nil)
    user = FactoryBot.create(:specialist).user if user.blank?
    login_user(user)
  end

  def login_user(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end

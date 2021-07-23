# frozen_string_literal: true

module ControllerHelper
  def login_business_user(business_user = nil)
    business_user = FactoryBot.create(:business).user if business_user.blank?
    login_user(business_user)
  end

  def login_user(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end

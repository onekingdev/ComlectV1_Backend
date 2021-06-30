# frozen_string_literal: true

module ControllerHelper
  def login_user(user = nil)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user = FactoryBot.create(:business).user if user.blank?

    sign_in user
  end
end

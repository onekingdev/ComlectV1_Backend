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

  def get_specialist_token(user = nil)
    user = FactoryBot.create(:specialist).user if user.blank?
    JsonWebToken.encode(sub: user.id, jwt_hash: user.jwt_hash)
  end

  def get_business_token(user = nil)
    user = FactoryBot.create(:business).user if user.blank?
    JsonWebToken.encode(sub: user.id, jwt_hash: user.jwt_hash)
  end
end

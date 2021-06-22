# frozen_string_literal: true

module Devise
  module Strategies
    class JWT < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        token = request.headers["Authorization"]
        payload = JsonWebToken.decode(token)
        user = User.find(payload['sub'])
        success! if user.jwt_hash == payload['jwt_hash']
      rescue ::JWT::ExpiredSignature
        fail! I18n.t('devise.failure.token_expired')
      rescue ::JWT::DecodeError
        fail! I18n.t('devise.failure.invalid_token')
      end

      def store?
        false
      end
    end
  end
end

Warden::Strategies.add(:jwt, Devise::Strategies::JWT)

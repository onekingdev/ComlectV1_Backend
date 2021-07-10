# frozen_string_literal: true

module ActiveAdmin
  module AuthenticationHelpers
    extend ActiveSupport::Concern

    private

    def authenticate_super_admin_user!
      return authenticate_admin_user! unless admin_user_signed_in?
      # render_404 unless current_admin_user.super_admin?
    end

    def authenticate_support_user!
      # Any superadmin can also login:
      authenticate_admin_user!
    end
  end
end

# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def scope
      Pundit.policy_scope!(user, record.class)
    end

    def show?
      case record.name
      when 'Dashboard'
        true
      else
        user.super_admin?
      end
    end
  end
end

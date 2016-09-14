# frozen_string_literal: true
module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def scope
      Pundit.policy_scope!(user, record.class)
    end

    def show?
      true
      # case record.name
      # when 'Dashboard'
      #   true
      # else
      #   false
      # end
    end
  end
end

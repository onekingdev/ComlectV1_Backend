# frozen_string_literal: true
ActiveAdmin::Dependency.pundit!

require 'pundit'

# Add a setting to the application to configure the pundit default policy
ActiveAdmin::Application.inheritable_setting :pundit_default_policy, nil

module ActiveAdmin
  class PunditAdminAdapter < PunditAdapter
    def scope_collection(collection, _action = Auth::READ)
      # scoping is appliable only to read/index action
      # which means there is no way how to scope other actions
      policy_class.new(user, collection).scope
    rescue Pundit::NotDefinedError => e
      raise e unless default_policy_class && default_policy_class.const_defined?(:Scope)
      default_policy_class::Scope.new(user, collection).resolve
    end

    def retrieve_policy(subject)
      case subject
      when nil   then policy_class.new(user, resource)
      when Class then policy_class.new(user, subject.new)
      else policy_class.new(user, subject)
      end
    rescue Pundit::NotDefinedError => e
      raise e unless default_policy_class
      default_policy(user, subject)
    end

    def policy_class
      @_policy_class ||= "Admin#{resource.resource_class_name}Policy".constantize
    rescue NameError
      @_policy_class = default_policy_class
    end

    def default_policy_class
      AdminPolicy
    end
  end
end

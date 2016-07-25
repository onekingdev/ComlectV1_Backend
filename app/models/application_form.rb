# frozen_string_literal: true
module ApplicationForm
  extend ActiveSupport::Concern

  included do
    # class Decorator < Project
    class Decorator < "::#{name.deconstantize}".constantize
      def self.decorate(object)
        object.model_name.instance_variable_get('@klass')::Decorator.decorate(object)
      end
    end
  end

  class_methods do
    def model_name
      # Project::Form.model_name => Project.model_name
      name.deconstantize.constantize.model_name
    end
  end
end

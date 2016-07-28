# frozen_string_literal: true
module ApplicationForm
  extend ActiveSupport::Concern

  class_methods do
    def model_name
      # Project::Form.model_name => Project.model_name
      name.deconstantize.constantize.model_name
    end
  end
end

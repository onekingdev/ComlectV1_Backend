# frozen_string_literal: true
module ApplicationForm
  extend ActiveSupport::Concern

  class_methods do
    # Project::Form.model_name => Project.model_name
    delegate :model_name, to: :superclass
  end
end

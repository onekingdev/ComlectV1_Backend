# frozen_string_literal: true

class TurnkeySolution < ActiveRecord::Base
  belongs_to :turnkey_page
  has_many :project_templates
  accepts_nested_attributes_for :project_templates, allow_destroy: true
end

# frozen_string_literal: true
class Skill < ActiveRecord::Base
  has_and_belongs_to_many :projects

  before_save -> { self.name = "##{name}" unless name.starts_with?('#') }
end

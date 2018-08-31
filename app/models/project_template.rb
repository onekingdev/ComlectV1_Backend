# frozen_string_literal: true

class ProjectTemplate < ActiveRecord::Base
  belongs_to :turnkey_solution
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
end

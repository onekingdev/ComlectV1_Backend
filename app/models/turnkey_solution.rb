# frozen_string_literal: true

class TurnkeySolution < ActiveRecord::Base
  belongs_to :turnkey_page
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
end

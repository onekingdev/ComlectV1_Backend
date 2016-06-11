# frozen_string_literal: true
class Industry < ActiveRecord::Base
  has_and_belongs_to_many :businesses
end

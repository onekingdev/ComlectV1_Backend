# frozen_string_literal: true
class Specialist::Search
  include ActiveModel::Model

  SORT_BY = { 'Sort by Rating' => 'rating', 'Sort by Experience' => 'experience' }.freeze

  attr_accessor :sort_by, :keyword, :jurisdiction_ids, :industry_ids, :rating, :experience, :regulator, :location,
                :location_range

  def initialize(attributes = HashWithIndifferentAccess.new)
    self.sort_by = 'rating' unless attributes.key?('sort_by')
    attributes.each do |attr, value|
      public_send "#{attr}=", value
    end
  end
end

# frozen_string_literal: true

class IndustrySerializer < ApplicationSerializer
  attributes :id, :name, :short_name, :sub_industries, :sub_industries_specialist
end

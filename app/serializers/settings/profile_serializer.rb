# frozen_string_literal: true

class Settings::ProfileSerializer < ApplicationSerializer
  attributes :photo,
             :first_name,
             :last_name
end

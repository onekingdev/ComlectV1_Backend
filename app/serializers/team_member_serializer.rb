# frozen_string_literal: true

class TeamMemberSerializer < ApplicationSerializer
  attributes \
    :id,
    :email,
    :last_name,
    :first_name,
    :start_date,
    :access_person
end

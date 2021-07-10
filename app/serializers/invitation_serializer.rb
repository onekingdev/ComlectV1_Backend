# frozen_string_literal: true

class InvitationSerializer < ApplicationSerializer
  attributes :id,
             :specialist_id,
             :first_name,
             :last_name,
             :email,
             :status,
             :team_id,
             :role
end

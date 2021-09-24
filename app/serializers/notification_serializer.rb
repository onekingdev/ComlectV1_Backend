# frozen_string_literal: true

class NotificationSerializer < ApplicationSerializer
  attributes :id,
             :action_path,
             :img_path,
             :initiator,
             :message,
             :created_at,
             :read_at,
             :clear_manually
end

# frozen_string_literal: true

namespace :discourse do
  task set_user_ids: :environment do
    [
      Specialist.where.not(discourse_username: [nil, '']).where(discourse_user_id: nil).to_a,
      Business.where.not(discourse_username: [nil, '']).where(discourse_user_id: nil).to_a
    ].flatten.each do |record|
      api = DiscourseUser.for(record).api
      begin
        puts record.discourse_username
        response = api.get "/users/#{record.discourse_username}"
      rescue DiscourseApi::NotFoundError, DiscourseApi::UnauthenticatedError
        next
      end
      record.update_attribute :discourse_user_id, response.body['user']['id']
    end
  end
end

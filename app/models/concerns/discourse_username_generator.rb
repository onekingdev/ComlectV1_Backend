# frozen_string_literal: true

module DiscourseUsernameGenerator
  extend ActiveSupport::Concern

  def discourse_username!(base)
    return discourse_username if discourse_username == base
    count = 0
    loop do
      self.discourse_username = count.positive? ? "#{base}_#{count}" : base
      break if self.class.where(discourse_username: discourse_username).empty?
      count += 1
    end
    update_attribute :discourse_username, discourse_username
    discourse_username
  end
end

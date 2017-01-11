# frozen_string_literal: true
class Flag::Create < Draper::Decorator
  decorates Flag
  delegate_all

  def self.call(user, flagged_content, attributes)
    new(Flag.new(attributes)).tap do |flag|
      flag.flagger = user
      flag.flagged_content = flagged_content
      flag.save!
      FlagMailer.deliver_later :flagged_content, flag.id
    end
  end
end

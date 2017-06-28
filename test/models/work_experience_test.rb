# frozen_string_literal: true

require 'test_helper'

class WorkExperienceTest < ActiveSupport::TestCase
  test 'from date must be after to date' do
    exp = WorkExperience.new(from: Time.zone.today, to: Time.zone.yesterday)
    assert exp.invalid?
    assert exp.errors[:from].present?
  end
end

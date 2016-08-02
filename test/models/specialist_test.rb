# frozen_string_literal: true
require 'test_helper'

class SpecialistTest < ActiveSupport::TestCase
  test 'sort by_experience' do
    specialist_1 = create(:specialist)
    specialist_1.work_experiences.create! from: Date.new(2005, 1, 1), to: Date.new(2010, 1, 1)
    specialist_2 = create(:specialist)
    specialist_2.work_experiences.create! from: Date.new(2001, 1, 1), to: Date.new(2003, 1, 1)
    assert_equal specialist_1.id, Specialist.by_experience.first.id
    specialist_1.work_experiences.first.update_attribute :from, Date.new(2009, 1, 1)
    assert_equal specialist_2.id, Specialist.by_experience.first.id
    specialist_1.work_experiences.first.update_attributes! to: nil, current: true
    assert_equal specialist_1.id, Specialist.by_experience.first.id
  end
end

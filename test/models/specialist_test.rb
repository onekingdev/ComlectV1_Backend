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

  test 'sort by_distance' do
    point_1 = [35.2456, -101.8103]
    specialist_1 = create(:specialist, lat: point_1[0] + 0.5, lng: point_1[1] + 0.5)
    specialist_2 = create(:specialist, lat: point_1[0] + 0.1, lng: point_1[1] + 0.1)
    ids = Specialist.by_distance(point_1[0], point_1[1]).pluck(:id)
    assert_equal [specialist_2.id, specialist_1.id], ids
  end

  test 'search close_to' do
    # Distance in km / miles: ~374 / ~233
    point_1 = [35.2456, -101.8103]
    point_2 = [35.7108, -105.8972]
    specialist_1 = create(:specialist, lat: point_1[0], lng: point_1[1])
    assert_nil Specialist.close_to(point_2[0], point_2[1], 200).first
    assert_equal specialist_1.id, Specialist.close_to(point_2[0], point_2[1], 300).first.id
  end

  test 'search between min-max distance' do
    # Distance in km / miles: ~374 / ~233
    point_1 = [35.2456, -101.8103]
    point_2 = [35.7108, -105.8972]
    specialist_1 = create(:specialist, lat: point_1[0], lng: point_1[1])
    assert_nil Specialist.distance_between(point_2[0], point_2[1], 100, 200).first
    assert_equal specialist_1.id, Specialist.distance_between(point_2[0], point_2[1], 200, 300).first.id
  end
end

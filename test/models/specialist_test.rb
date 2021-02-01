# frozen_string_literal: true

require 'test_helper'

class SpecialistTest < ActiveSupport::TestCase
  test 'sort by_experience' do
    specialist_1 = create(:specialist, work_experiences: [])
    create(
      :work_experience,
      specialist: specialist_1,
      compliance: true,
      from: 10.years.ago,
      length: 5.years
    )

    specialist_2 = create(:specialist, work_experiences: [])
    create(
      :work_experience,
      specialist: specialist_2,
      compliance: true,
      length: 2.years
    )
    specialist_1.save
    specialist_2.save

    assert_equal specialist_1.id, Specialist.by_experience.first.id
    specialist_1.reload.work_experiences.first.update_attribute(
      :from,
      specialist_1.work_experiences.first.to - 1.year
    )
    specialist_1.save

    assert_equal specialist_2.id, Specialist.by_experience.first.id
    specialist_1.work_experiences.first.update!(
      to: nil,
      current: true
    )
    specialist_1.save

    assert_equal specialist_1.id, Specialist.by_experience.first.id
  end

  test 'sort by_distance' do
    point_1 = [35.2456, -101.8103]
    specialist_1 = create(:specialist, lat: point_1[0] + 0.5, lng: point_1[1] + 0.5)
    specialist_2 = create(:specialist, lat: point_1[0] + 0.1, lng: point_1[1] + 0.1)
    ids = Specialist.by_distance(point_1[0], point_1[1]).pluck(:id)
    assert_equal [specialist_2.id, specialist_1.id], ids[0..1]
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

  test 'search between min-max experience' do
    specialist_1 = create(:specialist)
    create :work_experience,
           specialist_id: specialist_1.id,
           from: Date.new(2005, 1, 1),
           to: Date.new(2010, 1, 1),
           compliance: true
    create :work_experience, specialist_id: specialist_1.id, from: Date.new(2010, 1, 1), to: Date.new(2013, 1, 1)
    specialist_2 = create(:specialist)
    create :work_experience, specialist_id: specialist_2.id, from: Date.new(2001, 1, 1), to: Date.new(2003, 1, 1),
                             compliance: true

    specialist_1.save
    specialist_2.save
    results = Specialist.experience_between(3, 5).to_a
    assert_equal 1, results.size
    assert_equal specialist_1.id, results.first.id

    results = Specialist.experience_between(2, 5).to_a
    assert_equal 2, results.size
  end

  test 'returns messaged parties' do
    specialist_1 = create(:specialist)
    specialist_2 = create(:specialist)
    business_1 = create(:business)
    business_2 = create(:business)
    Message.create!(sender: specialist_1, recipient: business_1, message: 'Howdy')
    Message.create!(sender: specialist_2, recipient: business_2, message: 'Howdy 2')
    assert_equal [business_1.id], specialist_1.messaged_parties.pluck(:id)
    assert_equal [business_2.id], specialist_2.messaged_parties.pluck(:id)
  end
end

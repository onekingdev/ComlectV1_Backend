# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'sets full_time budget' do
    project = create :project_full_time, annual_salary: 50_000
    assert_equal 50_000, project.reload.calculated_budget
  end

  test 'sets one_off hourly budget' do
    project = create :project_one_off_hourly, hourly_rate: 500, estimated_hours: 8
    assert_equal 4000, project.reload.calculated_budget
  end

  test 'sets one_off fixed budget' do
    project = create :project_one_off_fixed, fixed_budget: 5_000
    assert_equal 5_000, project.reload.calculated_budget
  end

  test 'find project with pending business rating' do
    business = create(:business)
    specialist = create(:specialist)

    create(
      :project_one_off_fixed,
      business: business,
      fixed_budget: 5_000
    )

    project = create(
      :project_one_off_fixed,
      business: business,
      specialist: specialist,
      fixed_budget: 5_000
    )

    project_2 = create(
      :project_one_off_fixed,
      business: business,
      specialist: specialist,
      fixed_budget: 5_000
    )

    project.complete!
    project_2.complete!
    project_2.ratings.create!(rater: business, value: 4)

    assert_equal [project.id], business.projects.pending_business_rating.pluck(:id)
  end

  test 'find project with pending specialist rating' do
    business = create :business
    specialist = create :specialist
    create :project_one_off_fixed, business: business, fixed_budget: 5_000, specialist: specialist
    project = create :project_one_off_fixed, business: business, fixed_budget: 5_000, specialist: specialist
    project_2 = create :project_one_off_fixed, business: business, fixed_budget: 5_000, specialist: specialist
    project.complete!
    project_2.complete!
    project_2.ratings.create! rater: specialist, value: 4
    assert_equal [project.id], specialist.projects.pending_specialist_rating.pluck(:id)
  end
end

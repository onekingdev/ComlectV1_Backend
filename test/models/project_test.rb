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
end

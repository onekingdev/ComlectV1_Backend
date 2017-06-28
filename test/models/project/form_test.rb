# frozen_string_literal: true

require 'test_helper'

class Project::FormTest < ActiveSupport::TestCase
  test 'assigns hourly job fields' do
    project = Project::Form.new(
      pricing_type: 'hourly',
      hourly_payment_schedule: 'monthly',
      hourly_rate: 100,
      estimated_hours: 5,
      fixed_payment_schedule: 'fifty_fifty',
      fixed_budget: 500
    )
    project.save
    assert_equal 'monthly', project.payment_schedule
    assert_equal 100, project.hourly_rate
    assert_equal 5, project.estimated_hours
    assert_equal nil, project.fixed_budget
  end

  test 'assigns fixed job fields' do
    project = Project::Form.new(
      pricing_type: 'fixed',
      fixed_payment_schedule: 'fifty_fifty',
      fixed_budget: 500,
      estimated_hours: 50,
      hourly_payment_schedule: 'monthly',
      hourly_rate: 100
    )
    project.save
    assert_equal 'fifty_fifty', project.payment_schedule
    assert_equal 500, project.fixed_budget
    assert_equal 50, project.estimated_hours
    assert_equal nil, project.hourly_rate
  end
end

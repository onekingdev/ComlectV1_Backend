# frozen_string_literal: true
require 'test_helper'

class Business::HiresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business = create_business_with_valid_payment_source
    @specialist = create :specialist
    sign_in @business.user
  end

  test 'hires specialist' do
    project = create :project_full_time, :published, business: @business
    application = create :job_application, project: project, specialist: @specialist
    post business_project_hires_path(project), job_application_id: application.id, format: 'js'
    assert_response :success
    assert_equal @specialist.id, project.reload.specialist_id
  end

  test 'marks full time job complete after hiring' do
    project = create :project_full_time, :published, business: @business
    application = create :job_application, project: project, specialist: @specialist
    post business_project_hires_path(project), job_application_id: application.id, format: 'js'
    assert_response :success
    assert project.reload.complete?
  end

  test 'charges business upfront fee for full time hires' do
    project = create :project_full_time, :published, :upfront_fee, business: @business, annual_salary: 98_000
    application = create :job_application, project: project, specialist: @specialist
    assert_difference 'Charge.count', +1 do
      post business_project_hires_path(project), job_application_id: application.id, format: 'js'
    end
    assert_equal 14_700, project.charges.first.amount
  end

  test 'charges business monthly fee for full time hires' do
    starts_on = Date.new(2016, 1, 1)
    project = create :project_full_time, :published, :monthly_fee, business: @business, starts_on: starts_on
    application = create :job_application, project: project, specialist: @specialist
    assert_difference 'Charge.count', +6 do
      post business_project_hires_path(project), job_application_id: application.id, format: 'js'
    end
    fee_in_cents = project.annual_salary * 0.03 * 100
    charge_dates = Array.new(6) { |i| Date.new(2016, i + 1, 1) }
    assert_equal [fee_in_cents], project.charges.pluck(:amount_in_cents).uniq
    assert_equal charge_dates, project.charges.pluck(:process_after).sort
  end
end

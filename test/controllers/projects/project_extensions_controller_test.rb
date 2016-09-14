# frozen_string_literal: true
require 'test_helper'

class Projects::ProjectExtensionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business = create_business_with_valid_payment_source
    @specialist = create :specialist
    @project = create :project_one_off_hourly, business: @business, specialist: @specialist
    sign_in @specialist.user, 'password'
  end

  test 'accepted request extends project end date' do
    new_end_date = @project.ends_on + 1.week
    @project.extensions.create! new_end_date: new_end_date
    patch project_extension_path(@project), confirm: '1', format: :js
    assert_equal new_end_date, @project.reload.ends_on
  end
end

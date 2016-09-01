# frozen_string_literal: true
require 'test_helper'

class ProjectCreationTest < ActionDispatch::IntegrationTest
  setup do
    @business = create_business_with_valid_payment_source
    sign_in @business.user
  end

  test 'can create one off hourly project' do
    attributes = attributes_for(:project_one_off_hourly).merge(hourly_payment_schedule: 'monthly')
    assert_difference 'Project.count', +1 do
      post business_projects_path, project: attributes
    end
  end

  test 'can create one off fixed budget project' do
    attributes = attributes_for(:project_one_off_fixed).merge(fixed_payment_schedule: 'monthly')
    assert_difference 'Project.count', +1 do
      post business_projects_path, project: attributes
    end
  end

  test 'can create full time project' do
    attributes = attributes_for(:project_full_time).merge(full_time_starts_on: 1.month.ago)
    assert_difference 'Project.count', +1 do
      post business_projects_path, project: attributes
    end
  end

  test 'redirects draft saving to dashboard' do
    attributes = attributes_for(:project_full_time).merge(status: 'draft', full_time_starts_on: 1.month.ago)
    post business_projects_path, project: attributes
    assert_redirected_to business_dashboard_path
  end

  test 'redirects review and post to review page' do
    attributes = attributes_for(:project_full_time).merge(status: 'review', full_time_starts_on: 1.month.ago)
    post business_projects_path, project: attributes
    project = Project.last
    assert_redirected_to business_project_path(project)
  end

  test 'invites specialist after creating' do
    attributes = attributes_for(:project_full_time).merge(status: 'review', full_time_starts_on: 1.month.ago)
    specialist = create :specialist
    invite = @business.project_invites.create!(specialist: specialist, message: 'Invite')
    post business_projects_path, project: attributes.merge(invite_id: invite.id)
    post post_business_project_path(invite.reload.project), format: 'js'
    assert invite.reload.sent?
  end
end

# frozen_string_literal: true
require 'test_helper'

class ProjectCreationTest < ActionDispatch::IntegrationTest
  setup do
    @business = create :business
    @user = @business.user
    post user_session_path, 'user[email]' => @user.email, 'user[password]' => 'password'
  end

  test 'can create one off hourly project' do
    attributes = attributes_for(:project_one_off_hourly)
    assert_difference 'Project.count', +1 do
      post projects_path, project: attributes
    end
  end

  test 'can create one off fixed budget project' do
    attributes = attributes_for(:project_one_off_fixed)
    assert_difference 'Project.count', +1 do
      post projects_path, project: attributes
    end
  end

  test 'can create full time project' do
    attributes = attributes_for(:project_full_time)
    assert_difference 'Project.count', +1 do
      post projects_path, project: attributes
    end
  end

  test 'redirects draft saving to dashboard' do
    attributes = attributes_for(:project_full_time).merge(status: 'draft')
    post projects_path, project: attributes
    assert_redirected_to business_dashboard_path
  end

  test 'redirects review and post to review page' do
    attributes = attributes_for(:project_full_time).merge(status: 'review')
    post projects_path, project: attributes
    project = Project.last
    assert_redirected_to project_path(project)
  end
end

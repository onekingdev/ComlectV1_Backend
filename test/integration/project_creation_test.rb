# frozen_string_literal: true
require 'test_helper'

class ProjectCreationTest < ActionDispatch::IntegrationTest
  test 'can create one off hourly project' do
    user = create(:business).user
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'password'

    attributes = attributes_for(:project_one_off_hourly)
    assert_difference 'Project.count', +1 do
      post projects_path, project: attributes
    end
  end

  test 'can create one off fixed budget project' do
    user = create(:business).user
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'password'

    attributes = attributes_for(:project_one_off_fixed)
    assert_difference 'Project.count', +1 do
      post projects_path, project: attributes
    end
  end

  test 'can create full time project' do
    user = create(:business).user
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'password'

    attributes = attributes_for(:project_full_time)
    assert_difference 'Project.count', +1 do
      post projects_path, project: attributes
    end
  end
end

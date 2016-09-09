# frozen_string_literal: true
require 'test_helper'

class Business::ProjectsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "don't resend invite after editing published job" do
    business = create_business_with_valid_payment_source
    sign_in business.user, 'password'
    invite = create :project_invite, business: business, project: nil, message: 'Invited'
    attributes = attributes_for(:project_one_off_fixed).merge(fixed_payment_schedule: 'monthly', invite_id: invite.id)
    post business_projects_path, project: attributes
    project = Project.last
    assert_emails 1 do
      post post_business_project_path(project)
    end
    assert invite.reload.sent?
    assert_no_emails do
      put business_project_path(project), project: { title: 'New title' }
      assert_equal 'New title', project.reload.title
    end
  end
end

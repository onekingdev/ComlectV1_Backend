# frozen_string_literal: true

require 'test_helper'

class ProjectInvitesTest < ActionDispatch::IntegrationTest
  setup do
    @business = create :business
    @user = @business.user

    post_via_redirect(
      user_session_path,
      'user[email]' => @user.email,
      'user[password]' => 'password'
    )

    @specialist = create(:specialist)
  end

  test 'business gets set automatically' do
    pseudo_id = rand(10_000)
    params = { project_invite: { specialist_username: @specialist.username, message: pseudo_id } }
    post project_invites_path, params.merge(format: :js)
    invite = ProjectInvite.find_by!(message: pseudo_id)
    assert_equal @business.id, invite.business_id
  end

  test 'redirect when inviting to new project' do
    pseudo_id = rand(10_000)
    params = { project_invite: { specialist_id: @specialist.id, message: pseudo_id } }
    assert_difference 'ProjectInvite.count' do
      post project_invites_path, params.merge(format: :js)
    end
    invite = ProjectInvite.find_by!(message: pseudo_id)
    assert_match(/invite_id=#{invite.id}/, response.body)
  end

  test 'show message when inviting to existing project' do
    project = create(:project_full_time, business: @business)
    pseudo_id = rand(10_000)

    xhr :post, project_invites_path, project_invite: {
      project_id: project.id,
      specialist_id: @specialist.id,
      message: pseudo_id
    }

    assert_match(/js-project-invite/, response.body)
  end
end

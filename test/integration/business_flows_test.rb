# frozen_string_literal: true

require 'test_helper'

class BusinessFlowsTest < ActionDispatch::IntegrationTest
  setup do
    stub_request :post, /sync_sso/
  end

  test 'can create business' do
    attributes = attributes_for(:business)
    attributes[:user_attributes] = attributes_for(:user)
    attributes[:industry_ids] = [create(:industry).id]
    attributes[:user_attributes][:cookie_agreement_attributes] = attributes_for(:cookie_agreement, status: true)
    attributes[:user_attributes][:tos_agreement_attributes] = attributes_for(:tos_agreement, status: true)
    assert_difference 'Business.count + User.count', +2 do
      post businesses_path, business: attributes
    end
    assert_redirected_to business_dashboard_path
    get business_dashboard_path
    assert_response :ok
  end

  test "#new redirects to user's existing business" do
    user = create :user
    business = create :business, user: user
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'password'
    get new_business_path
    assert_redirected_to business_path(business)
  end

  test "#create redirects to user's existing business" do
    user = create :user
    business = create :business, user: user
    attributes = attributes_for(:business)
    attributes[:industry_ids] = [create(:industry).id]
    attributes[:user_attributes] = attributes_for(:user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'password'
    assert_no_difference 'Business.count + User.count' do
      post businesses_path, business: attributes
      assert_redirected_to business_path(business)
    end
  end

  test 'update business' do
    user = create(:user)
    business = create(:business, user: user)

    post_via_redirect(
      user_session_path,
      'user[email]' => user.email,
      'user[password]' => 'password'
    )

    patch(
      update_business_path,
      business: { business_name: 'New Name' }
    )

    assert_redirected_to business_dashboard_path
    assert_equal 'New Name', business.reload.business_name
  end
end

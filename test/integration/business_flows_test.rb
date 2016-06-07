# frozen_string_literal: true
require 'test_helper'

class BusinessFlowsTest < ActionDispatch::IntegrationTest
  test 'can create business' do
    attributes = attributes_for(:business)
    attributes[:user_attributes] = attributes_for(:user)
    assert_difference 'Business.count + User.count', +2 do
      post_via_redirect businesses_path, business: attributes
      assert_response :success
    end
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
    attributes[:user_attributes] = attributes_for(:user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => 'password'
    assert_no_difference 'Business.count + User.count' do
      post businesses_path, business: attributes
      assert_redirected_to business_path(business)
    end
  end

  test "signs in after sign up" do
    skip "TODO (test redirect to dashboard?)"
  end

  test "redirects specialist to root and flash" do
    skip "TODO"
  end
end

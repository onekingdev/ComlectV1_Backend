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

  test "redirects to user's existing business" do
    skip "TODO"
  end

  test "redirects specialist to root and flash" do
    skip "TODO"
  end
end

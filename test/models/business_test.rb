# frozen_string_literal: true

require 'test_helper'

class BusinessTest < ActiveSupport::TestCase
  test 'buils record with user' do
    business = Business.for_signup
    assert business.user.present?
  end

  test 'returns sent/received messages' do
    business = create :business
    other_business = create :business
    specialist = create :specialist
    included = []
    included << business.sent_messages.create!(recipient: specialist, message: 'dummy').id
    included << specialist.sent_messages.create!(recipient: business, message: 'dummy').id
    specialist.sent_messages.create! recipient: other_business, message: 'dummy'
    other_business.sent_messages.create! recipient: specialist, message: 'dummy'
    assert_equal included.sort, business.messages.pluck(:id).sort
  end
end

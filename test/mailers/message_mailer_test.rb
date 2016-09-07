# frozen_string_literal: true
require 'test_helper'

class MessageMailerTest < ActionMailer::TestCase
  setup do
    @business = create_business_with_valid_payment_source
    @specialist = create :specialist
    @thread = EmailThread.for!(@business, @specialist)
    ENV['POSTMARK_INBOUND_ADDRESS'] = 'inbound@test.com'
    ENV['DEFAULT_MAIL_FROM'] = 'from@complect'
  end

  test 'business messages specialist' do
    @business.expects(:anonymous?).at_least_once.returns(false)
    email = MessageMailer.first_contact(@business, @specialist, 'Howdy')
    assert_emails(1) { email.deliver_now }
    assert_equal ['from@complect'], email.from
    assert_equal [@specialist.user.email], email.to
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_equal "Message from #{@business.business_name} on Complect", email.subject
    assert_match(/#{@business.business_name}/, email.body.to_s)
  end

  test 'anonymous business messages specialist' do
    @business.expects(:anonymous?).at_least_once.returns(true)
    email = MessageMailer.first_contact(@business, @specialist, 'Howdy')
    assert_emails(1) { email.deliver_now }
    assert_equal ['from@complect'], email.from
    assert_equal [@specialist.user.email], email.to
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_equal "Message on Complect", email.subject
    assert_no_match(/#{@business.business_name}/, email.body.to_s)
  end

  test 'anonymous business replies to specialist' do
    Business.any_instance.expects(:anonymous?).at_least_once.returns(true)
    email = MessageMailer.reply(@thread, 'specialist', 'Howdy', '<p>Howdy</p>')
    assert_emails(1) { email.deliver_now }
    assert_equal ['from@complect'], email.from
    assert_equal @specialist.user.email, email.to.last
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_equal "Message on Complect", email.subject
    email.body.parts.each do |part|
      assert_no_match(/#{@business.business_name}/, part.body.to_s)
      assert_match(/Howdy/, part.body.to_s)
    end
  end

  test 'specialist replies' do
    Business.any_instance.expects(:anonymous?).at_least_once.returns(false)
    email = MessageMailer.reply(@thread, 'business', 'Howdy', '<p>Howdy</p>')
    assert_emails(1) { email.deliver_now }
    assert_equal ['from@complect'], email.from
    assert_equal @business.user.email, email.to.last
    assert_equal ["inbound+#{@thread.thread_key}+specialist@test.com"], email.reply_to
    assert_equal "Message from #{@specialist.first_name} on Complect", email.subject
    email.body.parts.each do |part|
      assert_match(/Howdy/, part.body.to_s)
    end
  end

  test 'business replies' do
    Business.any_instance.expects(:anonymous?).at_least_once.returns(false)
    email = MessageMailer.reply(@thread, 'specialist', 'Howdy', '<p>Howdy</p>')
    assert_emails(1) { email.deliver_now }
    assert_equal ['from@complect'], email.from
    assert_equal @specialist.user.email, email.to.last
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_equal "Message from #{@business.business_name} on Complect", email.subject
    email.body.parts.each do |part|
      assert_match(/Howdy/, part.body.to_s)
    end
  end
end

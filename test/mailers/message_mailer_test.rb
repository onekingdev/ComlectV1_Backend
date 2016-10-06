# frozen_string_literal: true
require 'test_helper'

class MessageMailerTest < ActionMailer::TestCase
  setup do
    ENV['POSTMARK_INBOUND_ADDRESS'] = 'inbound@test.com'
    ENV['DEFAULT_MAIL_FROM'] = 'complect@complect'
    @business = create_business_with_valid_payment_source
    @specialist = create :specialist
    @thread = EmailThread.for!(@business, @specialist)
    @project = create :project_one_off_hourly, business: @business, specialist: @specialist
  end

  test 'business messages specialist' do
    @business.expects(:anonymous?).at_least_once.returns(false)
    email = MessageMailer.first_contact(@business, @specialist, 'Howdy', @project)
    assert_emails(1) { email.deliver_now }
    assert_match(/complect/, email.from.first.to_s)
    assert_match(/complect/, email.to.first.to_s)
    assert_equal [@specialist.user.email], email.bcc
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_match(/subject: You received a message on Complect/, email.body.to_s)
    assert_match(/#{@project.title}/, email.body.to_s)
    assert_match(/#{@business.business_name}/, email.body.to_s)
  end

  test 'anonymous business messages specialist' do
    @business.expects(:anonymous?).at_least_once.returns(true)
    email = MessageMailer.first_contact(@business, @specialist, 'Howdy', @project)
    assert_emails(1) { email.deliver_now }
    assert_match(/complect/, email.from.first.to_s)
    assert_match(/complect/, email.to.first.to_s)
    assert_equal [@specialist.user.email], email.bcc
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_match(/You received a message on Complect/, email.body.to_s)
    assert_match(/#{@project.title}/, email.body.to_s)
    assert_no_match(/#{@business.business_name}/, email.body.to_s)
  end

  test 'anonymous business replies to specialist' do
    Business.any_instance.expects(:anonymous?).at_least_once.returns(true)
    email = MessageMailer.reply(@thread, 'specialist', 'Howdy', '<p>Howdy</p>')
    assert_emails(1) { email.deliver_now }
    assert_match(/complect/, email.from.first.to_s)
    assert_match(/complect/, email.to.first.to_s)
    assert_equal [@specialist.user.email], email.bcc
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_match(/RE: You received a message on Complect/, email.body.to_s)
    email.body.parts.each do |part|
      assert_no_match(/#{@business.business_name}/, part.body.to_s)
      assert_match(/Howdy/, part.body.to_s)
    end
  end

  test 'specialist replies' do
    Business.any_instance.expects(:anonymous?).at_least_once.returns(false)
    email = MessageMailer.reply(@thread, 'business', 'Howdy', '<p>Howdy</p>')
    assert_emails(1) { email.deliver_now }
    assert_match(/complect/, email.from.first.to_s)
    assert_match(/complect/, email.to.first.to_s)
    assert_equal [@business.user.email], email.bcc
    assert_equal ["inbound+#{@thread.thread_key}+specialist@test.com"], email.reply_to
    assert_match(/RE: You received a message on Complect/, email.body.to_s)
    email.body.parts.each do |part|
      assert_match(/Howdy/, part.body.to_s)
    end
  end

  test 'business replies' do
    Business.any_instance.expects(:anonymous?).at_least_once.returns(false)
    email = MessageMailer.reply(@thread, 'specialist', 'Howdy', '<p>Howdy</p>')
    assert_emails(1) { email.deliver_now }
    assert_match(/complect/, email.from.first.to_s)
    assert_match(/complect/, email.to.first.to_s)
    assert_equal [@specialist.user.email], email.bcc
    assert_equal ["inbound+#{@thread.thread_key}+business@test.com"], email.reply_to
    assert_match(/RE: You received a message on Complect/, email.body.to_s)
    email.body.parts.each do |part|
      assert_match(/Howdy/, part.body.to_s)
    end
  end
end

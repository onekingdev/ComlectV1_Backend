# frozen_string_literal: true
require 'test_helper'

class EmailThreadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business = create_business_with_valid_payment_source
    @specialist = create :specialist
    @thread = EmailThread.for!(@business, @specialist)
  end

  test 'post reply' do
    token, host = ENV.fetch('POSTMARK_INBOUND_ADDRESS').split('@')
    params = {
      'ToFull' => [{
        'Email' => "#{token}+#{@thread.thread_key}s@#{host}",
        'MailboxHash' => "#{@thread.thread_key}s"
      }],
      'TextBody' => 'Text',
      'HtmlBody' => 'Html',
      'StrippedTextReply' => 'Stripped'
    }
    post email_threads_path, params.to_json, 'CONTENT_TYPE' => 'application/json'
    assert_response :ok
  end
end

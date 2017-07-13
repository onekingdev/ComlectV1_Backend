# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Flagging content", type: :request do
  include SessionsHelper

  let(:specialist) { create :specialist }
  let(:project) { create :project_one_off_hourly, :published }
  let(:business) { project.business }
  let(:question) { project.questions.create!(text: 'Dummy', specialist: specialist) }

  before do
    sign_in business.user
  end

  it 'sends email to complect' do
    expect do
      post business_project_flags_path(
        project.id,
        flag: { reason: { 's' => 'Spam' }, question_id: question.id }
      )
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    message = ActionMailer::Base.deliveries.last
    expect(message.subject).to match(/flagged/i)
  end
end

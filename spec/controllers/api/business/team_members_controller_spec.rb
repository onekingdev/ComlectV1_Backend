# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::TeamMembersController, type: :controller do
  before(:each) do
    login_as_business
  end

  describe 'POST create' do
    context 'raises ParameterMissing exception' do
      it { expect { post(:create, {}) }.to raise_error ActionController::ParameterMissing }
      it { expect { post(:create, as: 'json', params: { team_member: {} }) }.to raise_error ActionController::ParameterMissing }
    end

    context 'without empty params' do
      let(:params) { { email: '', first_name: '', last_name: '' } }

      before { post :create, as: 'json', params: { team_member: params } }

      it { expect(response).to have_http_status(422) }
      it { expect(response.message).to eq('Unprocessable Entity') }
      it { expect(JSON.parse(response.body)['errors']['email']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['last_name']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['first_name']).to eq(['Required field']) }
    end

    context 'team member' do
      let(:params) do
        {
          first_name: 'Team',
          last_name: 'Member',
          email: 'team@member.com',
          start_date: '2021-08-22',
          access_person: '1'
        }
      end

      before do
        expect(TeamMember.count).to eq(1)
        post :create, as: 'json', params: { team_member: params }
      end

      it { expect(response).to have_http_status(201) }
      it { expect(response.message).to eq('Created') }

      it { expect(TeamMember.count).to eq(2) }
      it { expect(TeamMember.last.name).to eq('Team Member') }

      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['first_name']).to eq('Team') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Member') }
      it { expect(JSON.parse(response.body)['email']).to eq('team@member.com') }
      it { expect(JSON.parse(response.body)['start_date']).to eq('2021-08-22') }
      it { expect(JSON.parse(response.body)['access_person']).to be_truthy }
    end
  end
end

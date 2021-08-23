# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::TeamMembersController, type: :controller do
  let(:business) { create(:business_with_subscription) }

  before(:each) do
    login_as_business(business.user)
  end

  describe 'GET index' do
    context 'empty list' do
      before do
        TeamMember.destroy_all
        get :index, as: 'json'
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)).to eq([]) }
    end

    context 'team member list' do
      before do
        TeamMember.last.update(role: 'admin', start_date: '2021-08-22')
        get :index, as: 'json'
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)[0]['name']).to be_present }
      it { expect(JSON.parse(response.body)[0]['email']).to be_present }
      it { expect(JSON.parse(response.body)[0]['role']).to eq('admin') }
      it { expect(JSON.parse(response.body)[0]['last_name']).to be_present }
      it { expect(JSON.parse(response.body)[0]['first_name']).to be_present }
      it { expect(JSON.parse(response.body)[0]['access_person']).to be_falsey }
      it { expect(JSON.parse(response.body)[0]['start_date']).to eq('2021-08-22') }
    end
  end

  describe 'POST create' do
    context 'raises ParameterMissing exception' do
      let(:error) { ActionController::ParameterMissing }

      it { expect { post(:create, {}) }.to raise_error(error) }
      it { expect { post(:create, as: 'json', params: { team_member: {} }) }.to raise_error(error) }
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

    context 'business cannot create team member without available seat' do
      let(:params) do
        {
          first_name: 'Team',
          last_name: 'Member',
          email: 'team@member.com',
          start_date: '2021-08-22',
          access_person: '1',
          role: 'basic'
        }
      end

      let(:msg) { 'User has not been added. Please purchase an additional seat.' }

      before do
        expect(TeamMember.count).to eq(1)
        expect(Notification::Deliver).not_to receive(:got_seat_assigned!)

        post :create, as: 'json', params: { team_member: params }
      end

      it { expect(TeamMember.count).to eq(1) }
      it { expect(response).to have_http_status(422) }
      it { expect(Specialist::Invitation.count).to eq(0) }
      it { expect(response.message).to eq('Unprocessable Entity') }
      it { expect(JSON.parse(response.body)['errors']['seat']).to eq([msg]) }
    end

    context 'business cannot set available seat for invalid team member' do
      let(:params) { { email: '', first_name: '', last_name: '' } }
      let(:msg) { 'User has not been added. Please purchase an additional seat.' }
      let!(:seat) { create(:seat, business: Business.first, subscription: Subscription.first) }

      before do
        expect(Seat.count).to eq(1)
        expect(TeamMember.count).to eq(1)
        expect(Business.last.seats.available).to be_present
        expect(Notification::Deliver).not_to receive(:got_seat_assigned!)

        post :create, as: 'json', params: { team_member: params }
      end

      it { expect(TeamMember.count).to eq(1) }
      it { expect(response).to have_http_status(422) }
      it { expect(Specialist::Invitation.count).to eq(0) }
      it { expect(response.message).to eq('Unprocessable Entity') }
      it { expect(JSON.parse(response.body)['errors']['seat']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['email']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['last_name']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['first_name']).to eq(['Required field']) }
    end

    context 'business creates team member successfully' do
      let!(:seat) { create(:seat, business: Business.first, subscription: Subscription.first) }

      let(:params) do
        {
          first_name: 'Team',
          last_name: 'Member',
          email: 'team@member.com',
          start_date: '2021-08-22',
          access_person: '1',
          role: 'basic'
        }
      end

      before do
        expect(Seat.count).to eq(1)
        expect(TeamMember.count).to eq(1)
        expect(Business.last.seats.available).to be_present
        expect(Notification::Deliver).to receive(:got_seat_assigned!)

        post :create, as: 'json', params: { team_member: params }
      end

      it { expect(TeamMember.count).to eq(2) }
      it { expect(response.message).to eq('Created') }
      it { expect(response).to have_http_status(201) }
      it { expect(Specialist::Invitation.count).to eq(1) }

      it { expect(TeamMember.last.name).to eq('Team Member') }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['role']).to eq('basic') }
      it { expect(JSON.parse(response.body)['first_name']).to eq('Team') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Member') }
      it { expect(JSON.parse(response.body)['access_person']).to be_truthy }
      it { expect(JSON.parse(response.body)['email']).to eq('team@member.com') }
      it { expect(JSON.parse(response.body)['start_date']).to eq('2021-08-22') }
    end
  end
end

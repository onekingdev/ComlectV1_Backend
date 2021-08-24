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

    context 'with wrong role' do
      let(:params) { { email: '', first_name: '', last_name: '', role: 'Wrong' } }

      before { post :create, as: 'json', params: { team_member: params } }

      it { expect(response).to have_http_status(422) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(response.message).to eq('Unprocessable Entity') }
      it { expect(JSON.parse(response.body)['error']).to eq("'Wrong' is not a valid role") }
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
        expect(Seat.last.assigned_at).to be_nil
        expect(Seat.last.team_member_id).to be_nil
        expect(Business.last.seats.available).to be_present
        expect(Notification::Deliver).to receive(:got_seat_assigned!)

        post :create, as: 'json', params: { team_member: params }
      end

      it { expect(TeamMember.count).to eq(2) }
      it { expect(response.message).to eq('Created') }
      it { expect(response).to have_http_status(201) }
      it { expect(Specialist::Invitation.count).to eq(1) }

      it { expect(Seat.last.assigned_at).not_to be_nil }
      it { expect(Seat.last.team_member_id).to eq(TeamMember.last.id) }

      it { expect(TeamMember.last.name).to eq('Team Member') }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['role']).to eq('basic') }
      it { expect(JSON.parse(response.body)['active']).to be_truthy }
      it { expect(JSON.parse(response.body)['first_name']).to eq('Team') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Member') }
      it { expect(JSON.parse(response.body)['access_person']).to be_truthy }
      it { expect(JSON.parse(response.body)['email']).to eq('team@member.com') }
      it { expect(JSON.parse(response.body)['start_date']).to eq('2021-08-22') }
    end

    context 'business cannot create team members with the same email ' do
      let!(:seat) { create(:seat, business: Business.first, subscription: Subscription.first) }

      let(:email) { 'same@test.emal' }
      let(:team) { Business.first.team }
      let!(:team_member) { create(:team_member, team_id: team.id, email: email) }

      let(:params) do
        {
          first_name: 'Team',
          last_name: 'Member',
          email: email,
          start_date: '2021-08-22',
          access_person: '1',
          role: 'basic'
        }
      end

      before do
        expect(Seat.count).to eq(1)
        expect(TeamMember.count).to eq(2)
        expect(Business.last.seats.available).to be_present
        expect(Notification::Deliver).not_to receive(:got_seat_assigned!)

        post :create, as: 'json', params: { team_member: params }
      end

      it { expect(TeamMember.count).to eq(2) }
      it { expect(Specialist::Invitation.count).to eq(0) }
      it { expect(JSON.parse(response.body)['errors']['email']).to eq(['has already been taken']) }
    end
  end

  describe 'PATCH update' do
    context 'raises ParameterMissing exception' do
      let(:error) { ActionController::ParameterMissing }

      it { expect { patch(:update, as: 'json', params: { id: 0 }) }.to raise_error(error) }
      it { expect { patch(:update, as: 'json', params: { id: 0, team_member: {} }) }.to raise_error(error) }
    end

    context 'return not found' do
      let(:params) { { email: '', first_name: '', last_name: '' } }

      before { patch :update, as: 'json', params: { id: 0, team_member: params } }

      it { expect(response).to have_http_status(404) }
      it { expect(response.message).to eq('Not Found') }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['error']).to eq('Record not found') }
    end

    context 'without empty params' do
      let(:team) { Business.first.team }
      let!(:team_member) { create(:team_member, team_id: team.id) }
      let(:params) { { email: '', first_name: '', last_name: '' } }

      before do
        expect(TeamMember.count).to eq(2)
        expect(Notification::Deliver).not_to receive(:got_seat_assigned!)
        patch :update, as: 'json', params: { id: team_member.id, team_member: params }
      end

      it { expect(TeamMember.count).to eq(2) }
      it { expect(response).to have_http_status(422) }
      it { expect(Specialist::Invitation.count).to eq(0) }
      it { expect(response.message).to eq('Unprocessable Entity') }
      it { expect(JSON.parse(response.body)['errors']['email']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['last_name']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['first_name']).to eq(['Required field']) }
    end

    context 'update team member without sending invite' do
      let(:team) { Business.first.team }
      let!(:team_member) { create(:team_member, team_id: team.id) }

      let(:params) do
        {
          last_name: 'Name',
          first_name: 'User',
          access_person: '1',
          start_date: '2021-08-24'
        }
      end

      before do
        expect(TeamMember.count).to eq(2)
        expect(Notification::Deliver).not_to receive(:got_seat_assigned!)
        patch :update, as: 'json', params: { id: team_member.id, team_member: params }
      end

      it { expect(TeamMember.count).to eq(2) }
      it { expect(response).to have_http_status(200) }
      it { expect(Specialist::Invitation.count).to eq(0) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['name']).to eq('User Name') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Name') }
      it { expect(JSON.parse(response.body)['first_name']).to eq('User') }
      it { expect(JSON.parse(response.body)['start_date']).to eq('2021-08-24') }
    end

    context 'update team member email and send invite' do
      let(:team) { Business.first.team }
      let(:params) { { email: 'test@email.com' } }
      let!(:team_member) { create(:team_member, team_id: team.id) }
      let!(:specialist_invitation) { create(:specialist_invitation, team_id: team.id, team_member_id: team_member.id) }

      before do
        expect(TeamMember.count).to eq(2)
        expect(Notification::Deliver).to receive(:got_seat_assigned!).with(specialist_invitation, :new_employee) { true }
        patch :update, as: 'json', params: { id: team_member.id, team_member: params }
      end

      it { expect(TeamMember.count).to eq(2) }
      it { expect(response).to have_http_status(200) }
      it { expect(Specialist::Invitation.count).to eq(1) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['name']).to eq(team_member.name) }
      it { expect(JSON.parse(response.body)['last_name']).to eq(team_member.last_name) }
      it { expect(JSON.parse(response.body)['first_name']).to eq(team_member.first_name) }
    end
  end

  describe 'DELETE destroy' do
    context 'return not found' do
      before { delete :destroy, as: 'json', params: { id: 0 } }

      it { expect(response).to have_http_status(404) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['error']).to eq('Record not found') }
    end

    context 'return team member successfully' do
      let!(:team_member) { create(:full_team_member) }

      before do
        expect(Seat.count).to eq(1)
        expect(TeamMember.count).to eq(2)
        expect(Seat.last.assigned_at).not_to be_nil
        expect(Specialist::Invitation.count).to eq(1)
        expect(Seat.last.team_member_id).to eq(team_member.id)

        delete :destroy, as: 'json', params: { id: team_member.id }
      end

      it { expect(response).to have_http_status(200) }

      it { expect(Seat.count).to eq(1) }
      it { expect(TeamMember.count).to eq(1) }
      it { expect(Seat.last.assigned_at).to be_nil }
      it { expect(Seat.last.team_member_id).to be_nil }
      it { expect(Specialist::Invitation.count).to be_zero }

      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['name']).to eq('Team Member') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Member') }
      it { expect(JSON.parse(response.body)['first_name']).to eq('Team') }
    end
  end

  describe 'PATCH archive' do
    context 'return not found' do
      before { patch :archive, as: 'json', params: { id: 0 } }

      it { expect(response).to have_http_status(404) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['error']).to eq('Record not found') }
    end

    context 'archive team member' do
      let!(:team_member) { create(:full_team_member) }

      before do
        expect(Seat.count).to eq(1)
        expect(TeamMember.count).to eq(2)
        expect(Seat.last.assigned_at).not_to be_nil
        expect(Specialist::Invitation.count).to eq(1)
        expect(team_member.reload.active).to be_truthy
        expect(Seat.last.team_member_id).to eq(team_member.id)

        patch :archive, as: 'json', params: { id: team_member.id }
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }

      it { expect(Seat.count).to eq(1) }
      it { expect(TeamMember.count).to eq(2) }
      it { expect(Seat.last.assigned_at).to be_nil }
      it { expect(Seat.last.team_member_id).to be_nil }
      it { expect(team_member.reload.active).to be_falsey }
      it { expect(JSON.parse(response.body)['first_name']).to eq('Team') }
      it { expect(JSON.parse(response.body)['name']).to eq('Team Member') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Member') }
    end
  end

  describe 'PATCH unarchive' do
    context 'return not found' do
      before { patch :unarchive, as: 'json', params: { id: 0 } }

      it { expect(response).to have_http_status(404) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['error']).to eq('Record not found') }
    end

    context 'there is no available seat' do
      let(:team) { Business.first.team }
      let(:team_member) { create(:team_member, team_id: team.id, active: false) }
      let(:msg) { 'User has not been added. Please purchase an additional seat.' }

      before do
        expect(Seat.count).to be_zero
        expect(team_member.active).to be_falsey

        patch :unarchive, as: 'json', params: { id: team_member.id }
      end

      it { expect(response).to have_http_status(422) }

      it { expect(team_member.reload.active).to be_falsey }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['error']).to eq(msg) }
    end

    context 'successfully' do
      let(:team) { Business.first.team }
      let(:team_member) { create(:team_member, team_id: team.id, active: false) }
      let!(:seat) { create(:seat, business: Business.first, subscription: Subscription.first) }

      before do
        expect(Seat.count).to eq(1)
        expect(team_member.active).to be_falsey

        patch :unarchive, as: 'json', params: { id: team_member.id }
      end

      it { expect(response).to have_http_status(200) }

      it { expect(Seat.count).to eq(1) }
      it { expect(Seat.last.assigned_at).to be_present }
      it { expect(Seat.last.team_member_id).to eq(team_member.id) }

      it { expect(team_member.reload.active).to be_truthy }
      it { expect(JSON.parse(response.body)['error']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['first_name']).to eq('Team') }
      it { expect(JSON.parse(response.body)['name']).to eq('Team Member') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Member') }
    end
  end
end

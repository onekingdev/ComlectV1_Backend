# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Specialist::BillingsController, type: :controller do
  before(:each) do
    login_as_specialist
  end

  describe 'POST create' do
    context 'with blank params' do
      let(:params) { { account_type: '', country: '' } }

      before { post :create, as: 'json', params: params }

      it { expect(response).to have_http_status(422) }

      it { expect(assigns(:_current_specialist)).to be_present }
      it { expect(JSON.parse(response.body)['errors']['last_name']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['first_name']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['business_name']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['country']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['account_type']).to eq(['Required field']) }
    end

    context 'individual with blank params' do
      let(:params) { { account_type: 'individual' } }

      before { post :create, as: 'json', params: params }

      it { expect(response).to have_http_status(422) }

      it { expect(JSON.parse(response.body)['errors']['business_name']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['country']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['first_name']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['last_name']).to eq(['Required field']) }
    end

    context 'company with blank params' do
      let(:params) { { account_type: 'company' } }

      before { post :create, as: 'json', params: params }

      it { expect(response).to have_http_status(422) }

      it { expect(JSON.parse(response.body)['errors']['last_name']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['first_name']).to be_nil }
      it { expect(JSON.parse(response.body)['errors']['country']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['business_name']).to eq(['Required field']) }
    end

    context 'create individual stripe account' do
      let(:params) do
        {
          country: 'US',
          last_name: 'Last',
          first_name: 'First',
          account_type: 'individual'
        }
      end

      before { post :create, as: 'json', params: params }

      it { expect(response).to have_http_status(201) }

      it { expect(StripeAccount.count).to eq(1) }
      it { expect(StripeAccount.last.specialist_id).to be_present }
      it { expect(JSON.parse(response.body)['country']).to eq('US') }
      it { expect(JSON.parse(response.body)['business_name']).to be_nil }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Last') }
      it { expect(JSON.parse(response.body)['first_name']).to eq('First') }
      it { expect(JSON.parse(response.body)['account_type']).to eq('individual') }
    end

    context 'create business stripe account' do
      let(:params) do
        {
          country: 'US',
          account_type: 'company',
          business_name: 'Business name'
        }
      end

      before { post :create, as: 'json', params: params }

      it { expect(response).to have_http_status(201) }

      it { expect(StripeAccount.count).to eq(1) }
      it { expect(StripeAccount.last.specialist_id).to be_present }
      it { expect(JSON.parse(response.body)['country']).to eq('US') }
      it { expect(JSON.parse(response.body)['last_name']).to be_nil }
      it { expect(JSON.parse(response.body)['first_name']).to be_nil }
      it { expect(JSON.parse(response.body)['account_type']).to eq('company') }
      it { expect(JSON.parse(response.body)['business_name']).to eq('Business name') }
    end
  end

  describe 'PUT update' do
    context 'return not found' do
      before { patch :update, as: 'json', params: { id: 0 } }

      it { expect(response).to have_http_status(404) }
      it { expect(JSON.parse(response.body)['error']).to eq('Record not found') }
    end

    context 'update individual account information section' do
      let!(:stripe_account) { create(:individual_stripe_account, specialist: Specialist.last) }

      let(:params) do
        {
          country: 'CAN',
          last_name: 'Last',
          first_name: 'First',
          id: stripe_account.id,
          account_type: 'individual',
          section: 'account_information'
        }
      end

      before do
        expect(StripeAccount.count).to eq(1)
        patch :update, as: 'json', params: params
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['country']).to eq('CAN') }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Last') }
      it { expect(JSON.parse(response.body)['business_name']).to be_nil }
      it { expect(JSON.parse(response.body)['first_name']).to eq('First') }
      it { expect(JSON.parse(response.body)['account_type']).to eq('individual') }
    end

    context 'update company account information section' do
      let!(:stripe_account) { create(:company_stripe_account, specialist: Specialist.last) }

      let(:params) do
        {
          country: 'CAN',
          id: stripe_account.id,
          account_type: 'company',
          section: 'account_information',
          business_name: 'Business name'
        }
      end

      before do
        expect(StripeAccount.count).to eq(1)
        patch :update, as: 'json', params: params
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['last_name']).to be_nil }
      it { expect(JSON.parse(response.body)['first_name']).to be_nil }
      it { expect(JSON.parse(response.body)['country']).to eq('CAN') }
      it { expect(JSON.parse(response.body)['account_type']).to eq('company') }
      it { expect(JSON.parse(response.body)['business_name']).to eq('Business name') }
    end

    context 'update company account information section' do
      let!(:stripe_account) { create(:company_stripe_account, specialist: Specialist.last) }

      let(:params) do
        {
          country: '',
          account_type: '',
          id: stripe_account.id,
          section: 'account_information'
        }
      end

      before do
        expect(StripeAccount.count).to eq(1)
        patch :update, as: 'json', params: params
      end

      it { expect(response).to have_http_status(422) }
      it { expect(JSON.parse(response.body)['errors']['country']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['account_type']).to eq(['Required field']) }
    end
  end
end

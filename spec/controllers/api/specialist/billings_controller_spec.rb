# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Specialist::BillingsController, type: :controller do
  before(:each) do
    request.headers['Authorization'] = get_specialist_token
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

      before do
        # skip callbacks (they will be tested in model)
        expect_any_instance_of(StripeAccount).to receive(:create_managed_account) { true }
        post :create, as: 'json', params: params
      end

      it { expect(response).to have_http_status(201) }

      it { expect(StripeAccount.count).to eq(1) }
      it { expect(StripeAccount.last.specialist_id).to be_present }
      it { expect(JSON.parse(response.body)['country']['name']).to eq('United States') }
      it { expect(JSON.parse(response.body)['country']['value']).to eq('US') }
      it { expect(JSON.parse(response.body)['business_name']).to be_nil }
      it { expect(JSON.parse(response.body)['last_name']).to eq('Last') }
      it { expect(JSON.parse(response.body)['first_name']).to eq('First') }
      it { expect(JSON.parse(response.body)['account_type']['name']).to eq('Individual') }
      it { expect(JSON.parse(response.body)['account_type']['value']).to eq('individual') }
    end

    context 'create business stripe account' do
      let(:params) do
        {
          country: 'US',
          account_type: 'company',
          business_name: 'Business name'
        }
      end

      before do
        # skip callbacks (they will be tested in model)
        expect_any_instance_of(StripeAccount).to receive(:create_managed_account) { true }
        post :create, as: 'json', params: params
      end

      it { expect(response).to have_http_status(201) }

      it { expect(StripeAccount.count).to eq(1) }
      it { expect(StripeAccount.last.specialist_id).to be_present }
      it { expect(JSON.parse(response.body)['country']['name']).to eq('United States') }
      it { expect(JSON.parse(response.body)['country']['value']).to eq('US') }
      it { expect(JSON.parse(response.body)['last_name']).to be_nil }
      it { expect(JSON.parse(response.body)['first_name']).to be_nil }
      it { expect(JSON.parse(response.body)['account_type']['name']).to eq('Business') }
      it { expect(JSON.parse(response.body)['account_type']['value']).to eq('company') }
      it { expect(JSON.parse(response.body)['business_name']).to eq('Business name') }
    end
  end

  describe 'PUT update' do
    context 'return not found' do
      before { patch :update, as: 'json', params: { id: 0 } }

      it { expect(response).to have_http_status(404) }
      it { expect(JSON.parse(response.body)['error']).to eq('Record has not been found.') }
    end

    context 'update individual account information section' do
      let(:dob) { Time.zone.now - 18.years }
      let(:stripe_account) { create(:individual_stripe_account, specialist: Specialist.last) }

      let(:params) do
        {
          dob: dob,
          city: 'City',
          state: 'State',
          zipcode: 'zipcode',
          section: 'personal',
          address1: 'Address',
          id: stripe_account.id,
          personal_id_number: '000000000'
        }
      end

      before do
        # skip callbacks (they will be tested in model)
        expect_any_instance_of(StripeAccount).to receive(:create_managed_account) { true }
        stripe_account
        expect(StripeAccount.count).to eq(1)

        patch :update, as: 'json', params: params
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['city']).to eq('City') }
      it { expect(JSON.parse(response.body)['state']).to eq('State') }
      it { expect(JSON.parse(response.body)['address1']).to eq('Address') }
      it { expect(JSON.parse(response.body)['zipcode']).to eq('zipcode') }
      it { expect(JSON.parse(response.body)['dob']).to eq(dob.strftime('%Y-%m-%d')) }
      it { expect(JSON.parse(response.body)['personal_id_number']).to eq('000000000') }
      it { expect(JSON.parse(response.body)['account_type']['value']).to eq('individual') }
    end

    context 'update company account information section' do
      let(:dob) { Time.zone.now - 18.years }
      let(:stripe_account) { create(:company_stripe_account, specialist: Specialist.last) }

      let(:params) do
        {
          dob: dob,
          city: 'City',
          state: 'State',
          zipcode: 'zipcode',
          section: 'personal',
          address1: 'Address',
          id: stripe_account.id,
          business_tax_id: '000000000'
        }
      end

      before do
        # skip callbacks (they will be tested in model)
        expect_any_instance_of(StripeAccount).to receive(:create_managed_account) { true }
        stripe_account
        expect(StripeAccount.count).to eq(1)

        patch :update, as: 'json', params: params
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['errors']).to be_nil }
      it { expect(JSON.parse(response.body)['city']).to eq('City') }
      it { expect(JSON.parse(response.body)['state']).to eq('State') }
      it { expect(JSON.parse(response.body)['address1']).to eq('Address') }
      it { expect(JSON.parse(response.body)['zipcode']).to eq('zipcode') }
      it { expect(JSON.parse(response.body)['business_tax_id']).to eq('000000000') }
      it { expect(JSON.parse(response.body)['dob']).to eq(dob.strftime('%Y-%m-%d')) }
      it { expect(JSON.parse(response.body)['account_type']['value']).to eq('company') }
    end

    context 'update company account information section' do
      let(:stripe_account) { create(:company_stripe_account, specialist: Specialist.last) }

      let(:params) do
        {
          dob: '',
          city: '',
          state: '',
          zipcode: '',
          address1: '',
          business_tax_id: '',
          section: 'personal',
          id: stripe_account.id
        }
      end

      before do
        # skip callbacks (they will be tested in model)
        expect_any_instance_of(StripeAccount).to receive(:create_managed_account) { true }
        stripe_account

        expect(StripeAccount.count).to eq(1)

        patch :update, as: 'json', params: params
      end

      it { expect(response).to have_http_status(422) }
      it { expect(JSON.parse(response.body)['errors']['dob']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['city']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['state']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['zipcode']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['address1']).to eq(['Required field']) }
      it { expect(JSON.parse(response.body)['errors']['business_tax_id']).to eq(['Required field']) }
    end
  end
end

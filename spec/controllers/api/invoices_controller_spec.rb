# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::InvoicesController, type: :controller do
  describe 'GET index' do
    context 'business' do
      let(:business) { create(:business) }

      before(:each) do
        request.headers['Authorization'] = get_business_token(business.user)
      end

      context 'empty response' do
        before { get :index, as: 'json' }

        it { expect(response).to have_http_status(200) }
        it { expect(JSON.parse(response.body)).to eq([]) }
      end

      context 'success response' do
        let!(:invoice) { create(:invoice, business_id: business.id) }

        before { get :index, as: 'json' }

        it { expect(response).to have_http_status(200) }
        it { expect(JSON.parse(response.body)[0]['price']).to eq('$1') }
        it { expect(JSON.parse(response.body)[0]['date']).to be_present }
        it { expect(JSON.parse(response.body)[0]['currency']).to eq('usd') }
        it { expect(JSON.parse(response.body)[0]['price_in_cents']).to eq(100) }
        it { expect(JSON.parse(response.body)[0]['name']).to eq('Invoice name') }
        it { expect(JSON.parse(response.body)[0]['invoice_type']).to eq('plan') }
        it { expect(JSON.parse(response.body)[0]['invoice_pdf']).to eq('invoice_pdf_url') }
        it { expect(JSON.parse(response.body)[0]['hosted_invoice_url']).to eq('hosted_invoice_url') }
      end
    end
  end
end

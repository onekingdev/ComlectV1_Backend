# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::AnnualReportsController, type: :controller do
  before(:each) do
    login_user
  end

  describe 'GET clone' do
    context 'record not found' do
      it { expect { get :clone, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'valid annual_report' do
      let!(:annual_report) { create(:annual_report, business: Business.last) }

      before do
        expect(AnnualReport.count).to eq(1)
        get :clone, params: { id: annual_report.id }
      end

      it { expect(AnnualReport.count).to eq(2) }
      it { expect(response).to have_http_status(200) }
      it { expect(assigns(:areport)).to eq(annual_report) }
      it { expect(JSON.parse(response.body)['id']).not_to eq(annual_report.id) }
      it { expect(JSON.parse(response.body)['name']).to eq(annual_report.name) }
    end

    context 'invalid annual_report' do
      let!(:annual_report) { create(:annual_report, business: Business.last) }

      before do
        expect(AnnualReport.count).to eq(1)
        annual_report.update_attribute(:name, '')
        get :clone, params: { id: annual_report.id }
      end

      it { expect(AnnualReport.count).to eq(1) }
      it { expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity') }
      it { expect(JSON.parse(response.body)['errors']['name']).to eq(['required field']) }
    end
  end

  describe 'GET index' do
    let(:annual_report) { create(:annual_report, business: Business.last) }

    context 'successful request' do
      before do
        expect_any_instance_of(described_class).to(
          receive(:respond_with).with([annual_report], each_serializer: AnnualReportSerializer) { '' }
        )

        get :index
      end

      it { expect(response).to be_successful }
    end

    context 'annual reports blank' do
      before { get :index }

      it { expect(response.body).to eq('[]') }
      it { expect(response).to have_http_status(200) }
      it { expect(response.headers['Content-Type']).to eq 'application/json; charset=utf-8' }
    end

    context 'annual reports present' do
      let!(:expected_body) { JSON.parse(AnnualReportSerializer.new(annual_report).to_json) }

      before { get :index }

      it { expect(response.body).to eq([expected_body].to_json) }
      it { expect(JSON.parse(response.body)[0]['id']).to eq(annual_report.id) }
      it { expect(JSON.parse(response.body)[0]['name']).to eq(annual_report.name) }
    end
  end

  describe 'GET show' do
    let!(:annual_report) { create(:annual_report, business: Business.last) }

    context 'successful request' do
      before do
        expect_any_instance_of(described_class).to(
          receive(:respond_with).with(annual_report, serializer: AnnualReportSerializer) { '' }
        )

        get :show, params: { id: annual_report.id }
      end

      it { expect(response).to be_successful }
      it { expect(assigns(:areport)).to eq(annual_report) }
    end

    context 'record not found' do
      it { expect { get :show, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'record found' do
      let(:expected_body) { AnnualReportSerializer.new(annual_report).to_json }

      before { get :show, params: { id: annual_report.id } }

      it { expect(response).to have_http_status(200) }
      it { expect(response.body).to eq(expected_body) }
      it { expect(JSON.parse(response.body)['id']).to eq(annual_report.id) }
      it { expect(JSON.parse(response.body)['name']).to eq(annual_report.name) }
    end
  end

  describe 'POST create' do
    context 'parameter is missing' do
      it { expect { post :create, params: {} }.to raise_error(ActionController::ParameterMissing) }
    end

    context 'valid annual report' do
      let(:attr) { attributes_for(:annual_report) }

      before { post :create, params: { annual_report: attr } }

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(201) }
      it { expect(JSON.parse(response.body)['name']).to eq(attr[:name]) }
    end

    context 'annual report count changes' do
      let(:attr) { attributes_for(:annual_report) }
      it { expect { post :create, params: { annual_report: attr } }.to change { AnnualReport.count }.by(1) }
    end

    context 'unprocessable entity' do
      let(:attr) { attributes_for(:annual_report, name: '') }

      before { post :create, params: { annual_report: attr } }

      it { expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity') }
      it { expect(JSON.parse(response.body)['errors']['name']).to eq(['required field']) }
    end
  end

  describe 'PUT update' do
    context 'record not found' do
      let(:attr) { attributes_for(:annual_report) }
      it { expect { put :update, params: { id: 9999, annual_report: attr } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'with valid params' do
      let(:new_report_name) { 'New report name' }
      let!(:annual_report) { create(:annual_report, business: Business.last) }

      before do
        expect(annual_report.name).not_to eq(new_report_name)
        put :update, params: { id: annual_report.id, annual_report: { name: new_report_name } }
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(200) }
      it { expect(assigns(:areport)).to eq(annual_report) }
      it { expect(JSON.parse(response.body)['name']).to eq(new_report_name) }
    end

    context 'with invalid params' do
      let(:annual_report) { create(:annual_report, business: Business.last) }

      before { put :update, params: { id: annual_report.id, annual_report: { name: '' } } }

      it { expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity') }
      it { expect(JSON.parse(response.body)['errors']['name']).to eq(['required field']) }
    end
  end

  describe 'DELETE destroy' do
    context 'record not found' do
      it { expect { delete :destroy, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'annual report successfully' do
      let!(:annual_report) { create(:annual_report, business: Business.last) }

      before do
        expect(AnnualReport.count).to eq(1)
        delete :destroy, params: { id: annual_report.id }
      end

      it { expect(AnnualReport.count).to be_zero }
      it { expect(response).to have_http_status(200) }
      it { expect(assigns(:areport)).to eq(annual_report) }
      it { expect(JSON.parse(response.body)['name']).to eq(annual_report.name) }
    end

    context 'bad request' do
      let!(:annual_report) { create(:annual_report, business: Business.last) }

      before do
        expect(AnnualReport.count).not_to be_zero
        expect_any_instance_of(AnnualReport).to receive(:destroy) { false }
        delete :destroy, params: { id: annual_report.id }
      end

      it { expect(response.body).to be_empty }
      it { expect(AnnualReport.count).to eq(1) }
      it { expect(response).to have_http_status(400) }
    end
  end
end

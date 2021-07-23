# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Business::CompliancePoliciesController, type: :controller do
  before(:each) do
    login_user
  end

  describe 'GET index' do
    let(:compliance_policy) { create(:compliance_policy, business: Business.last) }

    context 'successful request' do
      before do
        expect_any_instance_of(described_class).to(
          receive(:respond_with).with([compliance_policy], each_serializer: CompliancePolicySerializer) { '' }
        )

        get :index
      end

      it { expect(response).to be_successful }
    end

    context 'compliance policies blank' do
      before { get :index }

      it { expect(response.body).to eq('[]') }
      it { expect(response).to have_http_status(200) }
      it { expect(response.headers['Content-Type']).to eq 'application/json; charset=utf-8' }
    end

    context 'compliance policies present' do
      let!(:expected_body) { JSON.parse(CompliancePolicySerializer.new(compliance_policy).to_json) }

      before { get :index }

      it { expect(response.body).to eq([expected_body].to_json) }
      it { expect(JSON.parse(response.body)[0]['id']).to eq(compliance_policy.id) }
      it { expect(JSON.parse(response.body)[0]['name']).to eq(compliance_policy.name) }
      it { expect(JSON.parse(response.body)[0]['status']).to eq(compliance_policy.status) }
    end
  end

  describe 'download' do
    context 'record not found' do
      it { expect { get :download, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'successful request' do
      let(:pdf) { 'PDF' }
      let(:file) { double('File') }
      let(:uploader) { double('PdfUploader') }
      let(:cpolicy) { create(:compliance_policy, business: Business.last) }

      let(:uploaded_file) {
        {
          'id' => 'test.pdf',
          'storage' => 'store',
          'metadata' => {
            'filename' => 'cpolicy_120210701-40814-1odgd7f.pdf',
            'size' => 1340,
            'mime_type' => 'application/pdf'
          }
        }
      }

      before do
        expect(cpolicy.pdf_data).to be_blank
        expect_any_instance_of(described_class).to(
          receive(:render_to_string).with(
            pdf: "Policy #{cpolicy.name}.pdf",
            template: 'business/compliance_policies/compliance_policy.pdf.erb',
            encoding: 'UTF-8',
            locals: { cpolicy: cpolicy },
            margin: { top: 0, bottom: 0, left: 0, right: 0 }
          ) { pdf }
        )

        expect(PdfUploader).to receive(:new).with(:store) { uploader }
        expect(Tempfile).to receive(:new).with(["cpolicy_#{cpolicy.id}", '.pdf']) { file }
        expect(file).to receive(:binmode) { 'return something' }
        expect(file).to receive(:write).with(pdf) { 'return something' }
        expect(file).to receive(:rewind) { 'return something' }
        expect(uploader).to receive(:upload).with(file) { uploaded_file }

        get :download, params: { id: cpolicy.id }
      end

      it { expect(assigns(:cpolicy)).to eq(cpolicy) }
      it { expect(response).to have_http_status(302) }
      it { expect(assigns(:cpolicy).pdf_data).to be_present }
      it { expect(response).to redirect_to('/uploads/store/test.pdf') }
    end
  end

  describe 'GET show' do
    let(:compliance_policy) { create(:compliance_policy, business: Business.last) }

    context 'record not found' do
      it { expect { get :show, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'successful request' do
      before do
        expect_any_instance_of(described_class).to(
          receive(:respond_with).with(compliance_policy, serializer: CompliancePolicySerializer) { '' }
        )

        get :show, params: { id: compliance_policy.id }
      end

      it { expect(response).to be_successful }
      it { expect(assigns(:cpolicy)).to eq(compliance_policy) }
    end

    context 'record found' do
      let(:expected_body) { CompliancePolicySerializer.new(compliance_policy).to_json }

      before { get :show, params: { id: compliance_policy.id } }

      it { expect(response).to have_http_status(200) }
      it { expect(response.body).to eq(expected_body) }
      it { expect(JSON.parse(response.body)['id']).to eq(compliance_policy.id) }
      it { expect(JSON.parse(response.body)['name']).to eq(compliance_policy.name) }
      it { expect(JSON.parse(response.body)['status']).to eq(compliance_policy.status) }
    end
  end

  describe 'DELETE destroy' do
    context 'record not found' do
      it { expect { delete :destroy, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'bad request for not archived compliance policy' do
      let!(:compliance_policy) { create(:compliance_policy, business: Business.last) }

      before do
        expect(CompliancePolicy.count).not_to be_zero
        delete :destroy, params: { id: compliance_policy.id }
      end

      it { expect(response.body).to be_empty }
      it { expect(CompliancePolicy.count).to eq(1) }
      it { expect(response).to have_http_status(400) }
    end

    context 'bad request for archived compliance policy' do
      let!(:compliance_policy) { create(:compliance_policy, business: Business.last, archived: true) }

      before do
        expect(CompliancePolicy.count).not_to be_zero
        expect_any_instance_of(CompliancePolicy).to receive(:destroy) { false }
        delete :destroy, params: { id: compliance_policy.id }
      end

      it { expect(CompliancePolicy.count).to eq(1) }
      it { expect(response).to have_http_status(400) }
    end

    context 'compliance policy successfully' do
      let!(:compliance_policy) { create(:compliance_policy, business: Business.last, archived: true) }

      before do
        expect(CompliancePolicy.count).to eq(1)
        delete :destroy, params: { id: compliance_policy.id }
      end

      it { expect(CompliancePolicy.count).to be_zero }
      it { expect(response).to have_http_status(200) }
      it { expect(assigns(:cpolicy)).to eq(compliance_policy) }
      it { expect(JSON.parse(response.body)['name']).to eq(compliance_policy.name) }
    end
  end

  describe 'POST create' do
    context 'valid compliance policy' do
      let(:attr) { attributes_for(:compliance_policy) }

      before { post :create, params: attr }

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(201) }
      it { expect(JSON.parse(response.body)['name']).to eq(attr[:name]) }
    end

    context 'compliance policy count changes' do
      let(:attr) { attributes_for(:compliance_policy) }
      it { expect { post :create, params: attr }.to change { CompliancePolicy.count }.by(1) }
    end

    context 'unprocessable entity' do
      let(:attr) { attributes_for(:compliance_policy, name: '') }

      before { post :create, params: attr }

      it { expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity') }
      it { expect(JSON.parse(response.body)['errors']['name']).to eq(['required field']) }
    end
  end

  describe 'GET publish' do
    context 'record not found' do
      it { expect { get :publish, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'bad request' do
      let(:compliance_policy) { create(:compliance_policy, business: Business.last, src_id: '9999') }

      before { get :publish, params: { id: compliance_policy.id } }

      it { expect(response).to have_http_status(400) }
    end

    context 'successful request' do
      let!(:compliance_policy) { create(:compliance_policy, business: Business.last) }

      before do
        expect(CompliancePolicy.count).to eq(1)
        expect(CompliancePolicy.first.src_id).to be_nil
        expect(CompliancePolicy.first.status).to eq('draft')

        get :publish, params: { id: compliance_policy.id }
      end

      it { expect(CompliancePolicy.count).to eq(2) }
      it { expect(response).to have_http_status(200) }
      it { expect(assigns(:cpolicy).src_id).to be_present }
      it { expect(assigns(:cpolicy)).to eq(compliance_policy) }
      it { expect(assigns(:cpolicy).status).to eq('published') }
      it { expect(JSON.parse(response.body)['id']).not_to eq(compliance_policy.id) }
      it { expect(JSON.parse(response.body)['name']).to eq(compliance_policy.name) }
      it { expect(JSON.parse(response.body)['status']).to eq(compliance_policy.status) }
    end

    context 'and update policy versions' do
      let!(:compliance_policy) { create(:compliance_policy, business: Business.last) }
      let!(:cpolicy_version) { create(:compliance_policy, business: Business.last, src_id: compliance_policy.id) }

      before do
        expect(CompliancePolicy.count).to eq(2)
        expect(cpolicy_version.src_id).to eq(compliance_policy.id)

        get :publish, params: { id: compliance_policy.id }
      end

      it { expect(CompliancePolicy.count).to eq(3) }
      it { expect(cpolicy_version.reload.src_id).to be_present }
      it { expect(cpolicy_version.reload.src_id).not_to eq(compliance_policy.id) }
    end
  end

  describe 'PUT update' do
    context 'record not found' do
      it { expect { put :update, params: { id: 9999 } }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'with invalid params' do
      let(:compliance_policy) { create(:compliance_policy, business: Business.last) }

      before { put :update, params: { id: compliance_policy.id, name: '' } }

      it { expect(JSON.parse(response.body)['status']).to eq('unprocessable_entity') }
      it { expect(JSON.parse(response.body)['errors']['name']).to eq(['required field']) }
    end

    context 'with valid params' do
      let(:new_policy_name) { 'New policy name' }
      let(:compliance_policy) { create(:compliance_policy, business: Business.last) }

      before do
        expect(compliance_policy.name).not_to eq(new_policy_name)
        put :update, params: { id: compliance_policy.id, name: new_policy_name }
      end

      it { expect(response).to be_successful }
      it { expect(response).to have_http_status(200) }
      it { expect(assigns(:cpolicy)).to eq(compliance_policy) }
      it { expect(JSON.parse(response.body)['name']).to eq(new_policy_name) }
    end
  end
end

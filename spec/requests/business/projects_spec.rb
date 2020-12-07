# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a project', type: :request do
  include SessionsHelper

  let(:industry) { create(:industry) }
  let(:jurisdiction) { create(:jurisdiction) }
  let(:business) { create(:business, :with_payment_profile) }

  before do
    sign_in business.user
    subject
  end

  context 'when rfp' do
    subject do
      post business_projects_path, project: {
        status: 'published',
        title: 'RFP',
        description: 'I need an RFTP',
        type: 'rfp',
        rfp_timing: 'asap',
        duration_type: 'custom',
        starts_on: '',
        ends_on: '',
        location_type: 'remote',
        industry_ids: [industry.id],
        jurisdiction_ids: [jurisdiction.id],
        minimum_experience: Project::MINIMUM_EXPERIENCE.first.last,
        pricing_type: 'hourly',
        est_budget: '10000'
      }
    end

    it 'redirects to the business dashboard' do
      expect(response).to redirect_to(business_dashboard_path(anchor: 'projects-pending'))
    end
  end

  context 'when one_off' do
    subject do
      post business_projects_path, project: {
        status: 'published',
        title: 'Foo',
        description: 'bar baz',
        type: 'one_off',
        duration_type: 'custom',
        starts_on: 1.month.from_now,
        ends_on: 2.months.from_now,
        location_type: 'remote',
        key_deliverables: 'Key deliverables',
        industry_ids: [industry.id],
        jurisdiction_ids: [jurisdiction.id],
        minimum_experience: Project::MINIMUM_EXPERIENCE.first.last,
        hourly_rate: '50',
        estimated_hours: '2',
        pricing_type: 'hourly',
        hourly_payment_schedule: 'upon_completion'
      }
    end

    it 'redirects to the business dashboard' do
      expect(response).to redirect_to(business_dashboard_path(anchor: 'projects-pending'))
    end
  end
end

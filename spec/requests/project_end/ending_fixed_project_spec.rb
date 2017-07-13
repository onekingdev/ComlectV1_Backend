# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fixed project end scenarios', type: :request do
  include SessionsHelper

  context 'early end approved' do
    let(:business) { create :business }
    let(:specialist) { create :specialist }
    # Budget: $10k, monthly pay
    let(:project) { create :project_one_off_fixed, :published, business: business, specialist: specialist }
    let(:end_request) { create :project_end, project: project }

    before do
      Timecop.freeze project.starts_on + 35.days
      PaymentCycle.for(project).create_charges_and_reschedule!
      project.charges.first.processed!
      end_request # Trigger creation
      sign_in specialist.user
      put project_end_path(project, confirm: '1', format: 'js')
      expect(response).to have_http_status(:ok)
      project.reload
    end

    after do
      Timecop.return
    end

    it "creates charge for balance with today's date" do
      expect(project.charges.count).to eq(2)
      statuses = [Charge.statuses[:processed], Charge.statuses[:scheduled]]
      expect(project.charges.map(&:status).uniq.sort).to eq(statuses)
      expect(project.charges.map(&:amount).reduce(:+)).to eq(project.fixed_budget)
      last = project.charges.scheduled.last
      expect(last.date).to eq(Time.zone.now)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fixed project end scenarios', type: :request do
  include SessionsHelper

  context 'early end approved' do
    let(:business) { create(:business, :with_payment_profile) }
    let(:specialist) { create(:specialist) }

    let(:project) {
      create(
        :project_one_off_fixed,
        :monthly_pay,
        business: business,
        fixed_budget: 10_000,
        starts_on: Date.new(2016, 1, 1),
        ends_on: Date.new(2016, 3, 1)
      )
    }

    let(:job_application) {
      create(
        :job_application,
        project: project,
        specialist: specialist
      )
    }

    let(:end_request) { create(:project_end, project: project) }

    before do
      StripeMock.start

      Timecop.freeze(business.tz.local(2015, 12, 25)) do
        Project::Form.find(project.id).post!
        JobApplication::Accept.(job_application)
      end

      Timecop.freeze(business.tz.local(2016, 2, 4)) do
        PaymentCycle.for(project).create_charges_and_reschedule!
        project.charges.first.processed!
        end_request # Trigger creation
        sign_in specialist.user
        put project_end_path(project, confirm: '1', format: 'js')
        expect(response).to have_http_status(:ok)
        project.reload
      end
    end

    after do
      StripeMock.stop
    end

    it "creates charge for balance with today's date" do
      expect(project.charges.count).to eq(2)
      statuses = [Charge.statuses[:processed], Charge.statuses[:scheduled]]
      expect(project.charges.map(&:status).uniq.sort).to eq(statuses)
      expect(project.charges.map(&:amount).reduce(:+)).to eq(project.fixed_budget)
      last = project.charges.scheduled.last
      expect(last.date.to_date).to eq(Date.new(2016, 2, 4))
    end
  end
end

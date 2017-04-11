# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Project end requests", type: :request do
  include SessionsHelper

  context 'project with an early end request' do
    let(:business) { create :business }
    let(:specialist) { create :specialist }
    let(:project) { create :project_one_off_hourly, :published, business: business, specialist: specialist }
    let(:timesheet) { create :timesheet, :submitted, project: project, hours: 10 }
    let(:end_request) { create :project_end, project: project }

    before do
      # Trigger creation
      Timecop.freeze(project.starts_on + 2.days) do
        timesheet
        end_request
      end
      Timecop.freeze project.ends_on.in_time_zone(business.tz) + 12.hours
    end

    after do
      Timecop.return
    end

    context 'specialist accepts request' do
      before do
        timesheet # trigger creation
        sign_in specialist.user
        put project_end_path(project, confirm: '1', format: 'js')
        expect(response).to have_http_status(:ok)
      end

      it 'does not auto-approve timesheet' do
        timesheet.reload
        expect(timesheet.status).to eq(Timesheet.statuses[:submitted])
      end
    end
  end
end

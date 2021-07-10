# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'database triggers' do
    context 'when project is full time' do
      let(:project) { create(:project_full_time, annual_salary: 50_000) }

      it 'calculates the budget' do
        expect(project.reload.calculated_budget).to eq 50_000
      end
    end

    context 'when project is one_off hourly' do
      let(:project) {
        create(
          :project_one_off_hourly,
          hourly_rate: 500,
          estimated_hours: 8
        )
      }

      it 'calculates the budget' do
        expect(project.reload.calculated_budget).to eq 4000
      end
    end

    context 'when project is one_off fixed' do
      let(:project) { create(:project_one_off_fixed, fixed_budget: 5000) }

      it 'calculates the budget' do
        expect(project.reload.calculated_budget).to eq 5000
      end
    end

    context 'when project is rfp' do
      let(:project) { create(:project, :rfp, est_budget: 5000) }

      it 'calculates the budget' do
        expect(project.reload.calculated_budget).to be_nil
      end
    end
  end

  describe '#hard_ends_on' do
    let(:tuesday_midnight) { Date.new(2017, 2, 27).in_time_zone('UTC').end_of_day }

    before do
      expect(subject).to receive(:time_zone).and_return(ActiveSupport::TimeZone['UTC'])
    end

    it 'ends on a friday, returns next monday (tue midnight)' do
      subject.ends_on = Date.new(2017, 2, 24)
      expect(subject.hard_ends_on).to eq(tuesday_midnight)
    end

    it 'ends on a saturday, returns next monday (tue midnight)' do
      subject.ends_on = Date.new(2017, 2, 25)
      expect(subject.hard_ends_on).to eq(tuesday_midnight)
    end

    it 'ends on a sunday, returns next monday (tue midnight)' do
      subject.ends_on = Date.new(2017, 2, 26)
      expect(subject.hard_ends_on).to eq(tuesday_midnight)
    end
  end

  describe '#expires_at' do
    let(:business) { build(:business, time_zone: 'Amsterdam') }

    let(:project) {
      build(
        :project_one_off_hourly,
        business: business,
        starts_on: Date.new(2016, 1, 1)
      )
    }

    it 'sets value to midnight of the start date on the business TZ' do
      project.save
      expected_expiration = Date.new(2016, 1, 1).in_time_zone('Amsterdam').end_of_day
      expect(project.expires_at).to eq(expected_expiration)
    end
  end

  describe '.new_project_notification' do
    let(:business) { build(:business, time_zone: 'Amsterdam') }

    let(:project) {
      build(
        :project_one_off_hourly,
        business: business,
        starts_on: Date.new(2016, 1, 1)
      )
    }

    it 'should call the right method after creation' do
      expect(project).to receive(:new_project_notification)
      project.save
    end
  end
end

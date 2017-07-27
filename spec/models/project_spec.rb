# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
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
end

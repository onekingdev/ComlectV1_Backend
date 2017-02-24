# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe '#hard_ends_on' do
    let(:tuesday_midnight) { DateTime.new(2017, 2, 28, 0, 0, 0).in_time_zone('UTC') }
    let(:wednesday_midnight) { DateTime.new(2017, 3, 1, 0, 0, 0).in_time_zone('UTC') }

    before do
      subject.expects(:time_zone).returns(ActiveSupport::TimeZone['UTC'])
    end

    it 'ends on a friday, returns next monday (tue midnight)' do
      subject.ends_on = Date.new(2017, 2, 24)
      expect(subject.hard_ends_on).to eq(tuesday_midnight)
    end

    it 'ends on a saturday, returns next tuesday (wed midnight)' do
      subject.ends_on = Date.new(2017, 2, 25)
      expect(subject.hard_ends_on).to eq(wednesday_midnight)
    end

    it 'ends on a sunday, returns next tuesday (wed midnight)' do
      subject.ends_on = Date.new(2017, 2, 26)
      expect(subject.hard_ends_on).to eq(wednesday_midnight)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe Jurisdiction, type: :model do
  describe '.ordered_starting_from_usa' do
    %w[Canada Africa Central\ America Asia South\ America Australia Europe].each do |name|
      Jurisdiction.find_or_create_by! name: name
    end

    it 'should return the jurisdictions in right order' do
      Jurisdiction.find_or_create_by!(name: 'USA')

      expect(Jurisdiction.last.name).to eq('USA')
      expect(Jurisdiction.ordered_starting_from_usa.first.name).to eq('USA')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecialistsBusinessRole, type: :model do
  let(:klass) { described_class }

  # columns
  # ======

  describe 'columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:business_id).of_type(:integer) }
    it { should have_db_column(:specialist_id).of_type(:integer) }
    it { should have_db_column(:role).of_type(:integer).with_options(default: :basic) }
    it { should have_db_column(:status).of_type(:string).with_options(default: 'active') }
  end

  # constants
  # =========

  describe 'constants' do
    it { expect(klass::ROLES).to eq(%w[basic admin trusted]) }
  end

  # associations
  # ============

  describe 'associations' do
    it { should belong_to(:business) }
    it { should belong_to(:specialist) }
  end

  # enums
  # =====

  describe 'enums' do
    it do
      should define_enum_for(:status)
        .with_values(active: 'active', inactive: 'inactive')
        .backed_by_column_of_type(:string)
    end

    it { should define_enum_for(:role).with_values(basic: 0, admin: 1, trusted: 2) }
  end

  # validations
  # =========

  describe 'validations' do
    it 'should allow valid role' do
      %w[basic admin trusted].each do |v|
        should allow_value(v).for(:role)
      end
    end
  end

  # delegates
  # =========

  describe 'delegates' do
    it { should delegate_method(:first_name).to(:specialist) }
    it { should delegate_method(:last_name).to(:specialist) }
    it { should delegate_method(:username).to(:specialist) }
  end
end

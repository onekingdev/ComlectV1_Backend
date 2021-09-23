# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  # columns
  # ======

  describe 'columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:date).of_type(:datetime) }
    it { should have_db_column(:currency).of_type(:string) }
    it { should have_db_column(:price).of_type(:integer) }
    it { should have_db_column(:stripe_invoice_id).of_type(:string) }
    it { should have_db_column(:invoice_pdf).of_type(:string) }
    it { should have_db_column(:stripe_charge_id).of_type(:string) }
    it { should have_db_column(:stripe_customer_id).of_type(:string) }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:hosted_invoice_url).of_type(:string) }
    it { should have_db_column(:invoice_type).of_type(:string).with_options(default: 'plan') }
    it { should have_db_column(:business_id).of_type(:integer) }
    it { should have_db_column(:specialist_id).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { should have_db_index(:business_id) }
    it { should have_db_index(:specialist_id) }
  end

  # associations
  # ============

  describe 'associations' do
    it { should belong_to(:business).optional }
    it { should belong_to(:specialist).optional }
  end

  # enums
  # =====

  describe 'enums' do
    it 'invoice_type' do
      should define_enum_for(:invoice_type)
        .with_values(plan: 'plan')
        .backed_by_column_of_type(:string)
    end
  end

  # validates
  # =========

  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:invoice_pdf) }
    it { should validate_presence_of(:stripe_invoice_id) }
    it { should validate_presence_of(:stripe_customer_id) }
  end
end

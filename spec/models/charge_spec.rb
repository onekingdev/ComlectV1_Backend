# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Charge, type: :model do
  let(:specialist) { create(:specialist) }
  let(:business) { create(:business, :with_payment_profile) }
  let(:project) do
    create(
      :project_one_off_fixed,
      business: business,
      payment_schedule: Project.payment_schedules[:monthly],
      fixed_budget: 1000,
      starts_on: Date.new(2016, 1, 1),
      ends_on: Date.new(2016, 2, 1)
    )
  end

  before do
    Timecop.freeze(business.tz.local(2015, 12, 25)) do
      job_application = create(
        :job_application,
        project: project,
        specialist: specialist
      )

      Project::Form.find(project.id).post!
      JobApplication::Accept.(job_application)
    end

    Timecop.freeze(project.starts_on + 1.day) do
      PaymentCycle.for(project).create_charges_and_reschedule!
    end
  end

  describe '#amount_with_stripe_fee' do
    it 'when amount includes stripe fee' do
      aggregate_failures do
        expect(business.charges.length).to eq(1)
        expect(business.charges.first.amount_with_stripe_fee).to eq(103_018)
        expect(business.charges.first.amount_in_cents).to eq(100_000)
        expect(business.charges.first.business_fee_in_cents).to eq(3168)
        expect(business.charges.first.specialist_fee_in_cents).to eq(10_000)
      end
    end
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StripeEvent::ChargeFailed, type: :model do
  # TODO
  # before do
  #   @specialist = create :specialist, stripe_account_id: 'acc_XXX'
  #   # @stripe_account = @specialist.stripe_accounts =
  #   @project = create :project_one_off_fixed,
  #                     payment_schedule: Project.payment_schedules[:bi_weekly],
  #                     fixed_budget: 10_000,
  #                     starts_on: 1.week.from_now,
  #                     ends_on: 2.months.from_now,
  #                     specialist_id: @specialist.id
  #   @transaction = create :transaction,
  #                         project: @project,
  #                         stripe_id: 'ch_00000000000000',
  #                         status: Transaction.statuses[:processed]
  # end
  #
  # describe 'charge failed event' do
  #   it 'resets the transaction to failed' do
  #     stub_request(:get, 'https://api.stripe.com/v1/events/dummy_event_id')
  #       .to_return(status: 200, body: File.read(Rails.root.join('spec/webmock/stripe_events/charge_failed.json')))
  #     StripeEvent.handle('dummy_event_id', 'acc_XXX', connect: true)
  #     @transaction.reload
  #     expect(@transaction.error?).to be(true)
  #   end
  # end
end

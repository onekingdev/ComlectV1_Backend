# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobApplication::Form do
  describe 'validations' do
    describe 'enough_experience?' do
      let!(:industry) { create(:industry) }
      let!(:jurisdiction) { create(:jurisdiction) }

      let!(:project) {
        create(
          :project,
          industry_ids: [industry.id],
          jurisdiction_ids: [jurisdiction.id],
          minimum_experience: 10
        )
      }

      let!(:specialist) {
        create(
          :specialist,
          industry_ids: [industry.id],
          jurisdiction_ids: [jurisdiction.id]
        )
      }

      let!(:experience1) {
        create(
          :work_experience,
          :compliance,
          specialist: specialist,
          from: Date.new(2014, 7, 14),
          to: Date.new(2016, 10, 3)
        )
      }

      let!(:experience2) {
        create(
          :work_experience,
          :compliance,
          specialist: specialist,
          from: Date.new(2012, 11, 7),
          to: Date.new(2014, 6, 7)
        )
      }

      let!(:experience3) {
        create(
          :work_experience,
          :compliance,
          specialist: specialist,
          from: Date.new(2006, 4, 1),
          to: Date.new(2012, 11, 1)
        )
      }

      let!(:experience4) {
        create(
          :work_experience,
          :compliance,
          :current,
          specialist: specialist,
          from: Date.new(2016, 11, 1),
          to: nil
        )
      }

      it 'is valid' do
        expect_any_instance_of(Specialist).to receive_message_chain(
          :stripe_account,
          :verified?
        ).and_return(true)

        application = JobApplication::Form.new(
          project: project,
          specialist: specialist
        )

        expect(application).to be_valid
      end
    end
  end
end

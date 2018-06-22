# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project::Form, type: :model do
  let!(:business) { create(:business, :with_payment_profile) }

  describe 'validations' do
    describe ':starts_asap' do
      let(:form) {
        Project::Form.new(business: business).tap do |form|
          form.assign_attributes project
        end
      }

      context 'when both :starts_on and :starts_asap are set' do
        let(:project) { attributes_for(:project_one_off_hourly, starts_asap: true) }

        it 'is not valid' do
          expect(form).not_to be_valid

          expect(
            form.errors.messages[:starts_asap]
          ).to include 'Cannot have both Start Date and Start ASAP'
        end
      end

      context 'when :starts_on is not set' do
        let(:project) {
          attributes_for(
            :project_one_off_hourly,
            starts_on: nil,
            starts_asap: true
          )
        }

        it 'is valid' do
          expect(form).to be_valid
        end
      end
    end
  end

  describe '#post' do
    let!(:project) { create(:project_one_off_hourly, business: business) }
    let!(:form) { Project::Form.find(project.id) }

    it 'publishes project' do
      form.post!
      expect(project.reload).to be_published
      expect(project.published_at).to be_truthy
    end
  end

  describe '#save' do
    let!(:project) { create(:project_one_off_hourly, business: business) }
    let!(:form) { Project::Form.find(project.id) }

    it 'publishes project' do
      form.assign_attributes(status: 'published')
      form.save
      expect(project.reload).to be_published
      expect(form.published_at).to be_truthy
    end
  end
end

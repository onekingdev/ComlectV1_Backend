# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project::Form, type: :model do
  let!(:business) { create(:business, :with_payment_profile) }

  describe 'validations' do
    let(:form) {
      Project::Form.new(business: business).tap do |form|
        form.assign_attributes project
      end
    }

    context 'when asap duration' do
      context 'with estimated_days present' do
        let(:project) {
          attributes_for(
            :project_one_off_hourly,
            :asap_duration,
            estimated_days: 15
          )
        }

        it 'is valid' do
          expect(form).to be_valid
        end
      end

      context 'without estimated_days present' do
        let(:project) {
          attributes_for(
            :project_one_off_hourly,
            :asap_duration,
            estimated_days: nil
          )
        }

        it 'is not valid' do
          expect(form).not_to be_valid
          expect(form.errors.messages.keys).to include :estimated_days
        end
      end

      context 'with starts_on and ends_on present' do
        let(:project) {
          attributes_for(
            :project_one_off_hourly,
            :asap_duration,
            starts_on: 1.month.from_now,
            ends_on: 1.month.from_now + 1.month
          )
        }

        it 'is not valid' do
          expect(form).not_to be_valid
          expect(form.errors.messages.keys).to include :starts_on
          expect(form.errors.messages.keys).to include :ends_on
        end
      end
    end

    context 'when custom duration' do
      context 'with estimated_days present' do
        let(:project) { attributes_for(:project_one_off_hourly) }

        it 'is valid' do
          expect(form.duration_type).to eq 'custom'
          expect(form.starts_on).to be_present
          expect(form.ends_on).to be_present
          expect(form.estimated_days).not_to be_present
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

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project::Form, type: :model do
  let!(:business) { create(:business, :with_payment_profile) }

  describe 'callbacks' do
    describe 'before_validation :assign_pricing_type_field' do
      before { project.save }

      context 'when hourly job' do
        subject(:project) do
          Project::Form.new(
            type: 'one_off',
            pricing_type: 'hourly',
            hourly_payment_schedule: 'monthly',
            hourly_rate: 100,
            estimated_hours: 5,
            fixed_payment_schedule: 'fifty_fifty',
            fixed_budget: 500
          )
        end

        it 'assigns fields' do
          expect(project.payment_schedule).to eq 'monthly'
          expect(project.hourly_rate).to eq 100
          expect(project.estimated_hours).to eq 5
          expect(project.fixed_budget).to be_nil
        end
      end

      context 'when fixed job' do
        subject(:project) do
          Project::Form.new(
            type: 'one_off',
            pricing_type: 'fixed',
            fixed_payment_schedule: 'fifty_fifty',
            fixed_budget: 500,
            estimated_hours: 50,
            hourly_payment_schedule: 'monthly',
            hourly_rate: 100
          )
        end

        it 'assigns fields' do
          expect(project.payment_schedule).to eq 'fifty_fifty'
          expect(project.fixed_budget).to eq 500
          expect(project.estimated_hours).to eq 50
          expect(project.hourly_rate).to be_nil
        end
      end
    end
  end

  describe 'validations' do
    let(:form) do
      obj = Project::Form.new(
        business: business,
        upper_hourly_rate: 100,
        role_details: 'role_details'
      )

      obj.tap do |form|
        form.assign_attributes project
      end
    end

    context 'when asap duration' do
      context 'with estimated_days present' do
        let(:project) do
          attributes_for(
            :project_one_off_hourly,
            :asap_duration,
            estimated_days: 15
          )
        end

        it 'is valid' do
          expect(form).to be_valid
        end
      end

      context 'without estimated_days present' do
        let(:project) do
          attributes_for(
            :project_one_off_hourly,
            :asap_duration,
            estimated_days: nil
          )
        end

        it 'is not valid' do
          expect(form).not_to be_valid
          expect(form.errors.messages.keys).to include :estimated_days
        end
      end

      context 'with starts_on and ends_on present' do
        let(:project) do
          attributes_for(
            :project_one_off_hourly,
            :asap_duration,
            starts_on: 1.month.from_now,
            ends_on: 1.month.from_now + 1.month
          )
        end

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
    let!(:project) do
      create(
        :project_one_off_hourly,
        business: business,
        role_details: 'role_details',
        upper_hourly_rate: 100
      )
    end

    let!(:form) { Project::Form.find(project.id) }

    it 'publishes project' do
      form.post!
      expect(project.reload).to be_published
      expect(project.published_at).to be_truthy
    end
  end

  describe '#save' do
    let!(:project) do
      create(
        :project_one_off_hourly,
        business: business,
        role_details: 'role_details',
        upper_hourly_rate: 100
      )
    end

    let!(:form) { Project::Form.find(project.id) }

    it 'publishes project' do
      form.assign_attributes(status: 'published')
      form.save
      expect(project.reload).to be_published
      expect(form.published_at).to be_truthy
    end
  end
end

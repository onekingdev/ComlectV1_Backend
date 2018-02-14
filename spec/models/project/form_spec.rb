# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project::Form, type: :model do
  before(:all) do
    StripeMock.start
  end

  after(:all) do
    StripeMock.stop
  end

  describe '#post' do
    let!(:business) { create(:business, :with_payment_profile) }
    let!(:project) { create(:project_one_off_hourly, business: business) }
    let!(:form) { Project::Form.find(project.id) }

    it 'publishes project' do
      form.post!
      expect(project.reload).to be_published
      expect(project.published_at).to be_truthy
    end
  end

  describe '#save' do
    let!(:business) { create(:business, :with_payment_profile) }
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

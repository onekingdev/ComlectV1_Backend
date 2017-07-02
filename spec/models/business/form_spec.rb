# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business::Form, type: :model do
  describe 'a business with a Discourse account' do
    let(:business) { create(:business) }

    before do
      business.discourse_username! business.business_name.parameterize.titleize.delete(' ')
    end

    describe 'when changing profile privacy' do
      it 'updates username and avatar' do
        form = Business::Form.for_user(business.user)
        expect_any_instance_of(DiscourseApi::Client).to receive(:get).and_return('user' => { 'id' => 1 })
        expect_any_instance_of(DiscourseApi::Client).to receive(:post)
        form.anonymous = true
        form.save validate: false
        expect(business.reload.discourse_username).to eq('Anonymous')
      end
    end
  end
end

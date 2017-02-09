# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Specialist::Form, type: :model do
  describe 'a specialist with a Discourse account' do
    let(:specialist) { create :specialist }

    before do
      specialist.discourse_username! specialist.full_name.parameterize.titleize.delete(' ')
    end

    describe 'when changing profile privacy' do
      it 'updates username and avatar' do
        form = Specialist::Form.for_user(specialist.user)
        DiscourseApi::Client.any_instance.expects(:post)
        form.visibility = Specialist.visibilities.fetch(:is_private)
        form.save validate: false
        expect(specialist.reload.discourse_username).to eq('Anonymous')
      end
    end
  end
end

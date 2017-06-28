# frozen_string_literal: true

require 'test_helper'

class JobApplicationTest < ActiveSupport::TestCase
  setup do
    @project = create :project_one_off_hourly
    @specialist = create :specialist
  end

  test '#not_accepted' do
    specialist_2 = create :specialist
    mine = @project.job_applications.create! specialist: @specialist
    not_mine = @project.job_applications.create! specialist: specialist_2
    assert_equal [], @specialist.job_applications.not_accepted.pluck(:id)
    @project.update_attribute :specialist_id, not_mine.specialist_id
    assert_equal [mine.id], @specialist.job_applications.not_accepted.pluck(:id)
  end

  test '#pending' do
    specialist_2 = create :specialist
    mine = @project.job_applications.create! specialist: @specialist
    not_mine = @project.job_applications.create! specialist: specialist_2
    assert_equal [mine.id], @specialist.job_applications.pending.pluck(:id)
    @project.update_attribute :specialist_id, not_mine.specialist_id
    assert_equal [], @specialist.job_applications.pending.pluck(:id)
  end
end

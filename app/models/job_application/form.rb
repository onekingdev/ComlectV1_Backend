# frozen_string_literal: true
class JobApplication::Form < Draper::Decorator
  decorates JobApplication
  delegate_all

  def self.apply!(specialist, project, params)
    # TODO: Send notification message to client
    specialist.job_applications.create(params.merge(project: project))
  end
end

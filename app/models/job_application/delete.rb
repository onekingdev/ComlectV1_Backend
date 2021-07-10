# frozen_string_literal: true

class JobApplication::Delete
  def self.call(application)
    application.destroy
    JobApplicationMailer.deliver_later :withdraw, application if application.destroyed?
  end
end

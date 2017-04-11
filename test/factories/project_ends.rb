# frozen_string_literal: true
FactoryGirl.define do
  factory :project_end do
    project
    expires_at do
      if project&.business
        BufferDate.for(project.business.tz.now, tz: project.business.tz)
      else
        BufferDate.for(Time.zone.now.tomorrow.end_of_day, tz: Time.zone)
      end
    end
  end
end

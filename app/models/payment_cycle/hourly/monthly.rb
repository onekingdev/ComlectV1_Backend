# frozen_string_literal: true

class PaymentCycle::Hourly::Monthly < PaymentCycle::Hourly
  private

  def occurrences
    # Skip first occurrence since it will be at the project's start date
    all = schedule.occurrences_between(project.starts_on, project.ends_on)[1..-1]

    # For too short projects, use the project's end date
    all << project.ends_on if all.empty?
    all
  end

  def schedule
    IceCube::Schedule.new(project.starts_on).tap do |schedule|
      schedule.add_recurrence_rule IceCube::Rule.monthly
    end
  end
end

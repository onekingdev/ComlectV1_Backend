# frozen_string_literal: true

class PaymentCycle::Hourly::BiWeekly < PaymentCycle::Hourly
  private

  def occurrences
    return @_occurrences if @_occurrences

    # Skip first occurrence since it will be at the project's start date
    @_occurrences = schedule.occurrences_between(
      project.starts_on.in_time_zone(timezone),
      project.ends_on.in_time_zone(timezone)
    )[1..-1]
  end

  def schedule
    IceCube::Schedule.new(project.starts_on.in_time_zone(timezone)).tap do |schedule|
      schedule.add_recurrence_rule IceCube::Rule.weekly(2)
    end
  end
end

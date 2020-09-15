# frozen_string_literal: true

class Reminder < ActiveRecord::Base
  belongs_to :remindable, polymorphic: true

  def start_time
    remind_at
  end

  def past_due?
    end_date < Time.zone.today
  end

  def self.week_grid(date)
    date
  end
end

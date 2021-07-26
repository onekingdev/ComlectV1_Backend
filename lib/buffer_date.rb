# frozen_string_literal: true

class BufferDate
  def self.for(date, time_zone:)
    datetime = date.in_time_zone(time_zone).end_of_day
    datetime + case datetime.wday
               when 5 then 3.days # friday -> monday (tues midnight)
               when 6 then 2.days # saturday -> monday (tues midnight)
               when 0 then 1.day # sunday -> monday (tues midnight)
               else
                 1.day
    end
  end
end

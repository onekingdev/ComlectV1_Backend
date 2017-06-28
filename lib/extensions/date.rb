# frozen_string_literal: true

class Date
  def distance_in_words_from(from)
    days = (from - self).to_i.abs + 1
    helper = ActionView::Base.new
    case days
    when 0..6
      helper.pluralize(days, 'Day', 'Days')
    else
      weeks = helper.pluralize(days / 7, 'Week', 'Weeks')
      remaining = days - (days / 7) * 7
      days = remaining.positive? ? helper.pluralize(remaining, 'Day', 'Days') : ''
      [weeks, days].join(' ')
    end
  end

  def to_a(zero_based_month: false)
    [year, month - (zero_based_month ? 1 : 0), day]
  end
end

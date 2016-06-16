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
      days = remaining > 0 ? helper.pluralize(remaining, 'Day', 'Days') : ''
      [weeks, days].join(' ')
    end
  end
end

# frozen_string_literal: true

class JobApplication::Decorator < Draper::Decorator
  decorates JobApplication
  delegate_all

  def payment_schedule_humanized
    Project::PAYMENT_SCHEDULES.find { |_key, value| value == payment_schedule }&.first
  end

  def key_deliverables_list
    h.content_tag 'ul', class: 'list-flush' do
      if key_deliverables.blank?
        h.content_tag 'li', 'N/A'
      else
        key_deliverables.split(',').map { |item| h.content_tag('li', item) }.join.html_safe
      end
    end
  end
end

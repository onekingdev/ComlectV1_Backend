# frozen_string_literal: true
class Admin::ChargeDecorator < AdminDecorator
  decorates Charge

  def to_s
    "Charge id #{id}"
  end

  def status_css_class
    {
      'estimated' => nil,
      'scheduled' => 'yes',
      'processed' => 'green',
      'error'     => 'red'
    }[status]
  end
end

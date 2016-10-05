# frozen_string_literal: true
class Admin::TransactionDecorator < AdminDecorator
  decorates Transaction

  def to_s
    "Transaction id #{id}"
  end

  def status_css_class
    {
      'processed' => 'green',
      'error'     => 'red'
    }[status]
  end
end

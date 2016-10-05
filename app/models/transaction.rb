# frozen_string_literal: true
class Transaction < ActiveRecord::Base
  belongs_to :project

  enum status: { pending: nil, processed: 'processed', error: 'error' }
end

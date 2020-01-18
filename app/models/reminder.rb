# frozen_string_literal: true

class Reminder < ActiveRecord::Base
  belongs_to :business

  def start_time
    remind_at
  end
end

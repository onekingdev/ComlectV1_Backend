# frozen_string_literal: true
class ProjectExtension < ActiveRecord::Base
  belongs_to :project

  enum status: { pending: nil, confirmed: 'confirmed', denied: 'denied' }

  def confirm!
    update_attribute :status, self.class.statuses[:confirmed]
  end

  def deny!
    update_attribute :status, self.class.statuses[:denied]
  end
end

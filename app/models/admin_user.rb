# frozen_string_literal: true

class AdminUser < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :admin, -> { where(super_admin: true) }
  scope :customer_representative, -> { where(super_admin: false) }

  def active_for_authentication?
    super && !suspended?
  end
end

# frozen_string_literal: true
class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :admin, -> { where(super_admin: true) }
  scope :cusomter_representative, -> { where(super_admin: false) }
end

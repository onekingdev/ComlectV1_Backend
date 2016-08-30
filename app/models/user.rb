# frozen_string_literal: true
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :business
  has_one :specialist
  has_many :project_issues, dependent: :delete_all
  has_many :notifications, dependent: :delete_all

  def payment_info?
    # TODO: Return true if payment info is available
    true
  end
end

# frozen_string_literal: true
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :business, dependent: :destroy
  has_one :specialist, dependent: :destroy
  has_many :business_projects, through: :business, source: :projects
  has_many :project_issues, dependent: :delete_all
  has_many :notifications, dependent: :delete_all

  def payment_info?
    # TODO: Return true if payment info is available
    true
  end

  def freeze_business_account!
    transaction do
      update_attribute :deleted, true
      business_projects.update_all status: Project.statuses[:complete]
      business.update_attribute :anonymous, true
    end
    reload
    deleted?
  end

  def active_for_authentication?
    super && !deleted?
  end
end

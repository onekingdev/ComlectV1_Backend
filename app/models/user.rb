# frozen_string_literal: true
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :business, dependent: :destroy
  has_one :specialist, dependent: :destroy
  has_many :business_projects, through: :business, source: :projects
  has_many :payment_sources, through: :business
  has_many :project_issues, dependent: :delete_all
  has_many :notifications, dependent: :delete_all

  def full_name
    if specialist
      [specialist.first_name, specialist.last_name].join(' ')
    else
      [business.contact_first_name, business.contact_last_name].join(' ')
    end
  end

  def payment_info?
    payment_sources.any?
  end

  def freeze!
    freeze_business_account! && touch(:deleted_at) if business
    freeze_specialist_account! && touch(:deleted_at) if specialist
  end

  def unfreeze!
    update_attribute :deleted, false
    update_attribute :deleted_at, nil
  end

  def freeze_business_account!
    transaction do
      update_attribute :deleted, true
      business_projects.active.update_all status: Project.statuses[:complete]
      business_projects.where.not(status: Project.statuses[:complete]).destroy_all
      business.update_attribute :anonymous, true
    end
    reload
    deleted?
  end

  def freeze_specialist_account!
    update_attribute :deleted, true
    # Withdraw active job applications
    specialist.job_applications.pending.each { |application| JobApplication::Delete.(application) }
    # And just delete all applications which weren't accepted to avoid sending notifications
    specialist.job_applications.not_accepted.delete_all
    specialist.update_attribute :visibility, Specialist.visibilities[:is_private]
    reload
    deleted?
  end

  def active_for_authentication?
    super && !deleted?
  end
end

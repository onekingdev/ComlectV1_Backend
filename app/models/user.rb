# frozen_string_literal: true

require 'validators/email_validator'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :business, dependent: :destroy
  has_one :specialist, dependent: :destroy
  has_many :business_projects, through: :business, source: :projects
  has_many :specialist_projects, through: :specialist, source: :projects
  has_many :payment_sources, through: :business
  has_many :project_issues, dependent: :delete_all
  has_many :notifications, dependent: :delete_all
  has_many :forum_answers
  has_many :forum_votes, dependent: :destroy
  has_one :tos_agreement, dependent: :destroy

  validates :email, presence: true, email: true

  accepts_nested_attributes_for :tos_agreement

  scope :inactive, -> {
    where('last_sign_in_at < ?', Time.zone.now - 90.days)
      .where(inactive_for_period: false, suspended: false)
  }

  default_scope -> { where(deleted: false) }

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
    freeze_business_account! if business
    freeze_specialist_account! if specialist
    touch :suspended_at
    update_attribute :suspended, true
  end

  def unfreeze!
    update_attribute :suspended, false
    update_attribute :suspended_at, nil
  end

  def freeze_business_account!
    transaction do
      create_dummy_issue business_projects.active, business
      business_projects.published.update_all status: Project.statuses[:draft]
      business.update_attribute :anonymous, true
    end
    reload
    suspended?
  end

  def freeze_specialist_account!
    create_dummy_issue specialist_projects.active, specialist
    # Withdraw active job applications
    specialist.job_applications.pending.each { |application| JobApplication::Delete.(application) }
    # And just delete all applications which weren't accepted to avoid sending notifications
    specialist.job_applications.not_accepted.delete_all
    specialist.update_attribute :visibility, Specialist.visibilities[:is_private]
    reload
    suspended?
  end

  def create_dummy_issue(projects, user)
    projects.each do |project|
      project.issues.create! issue: user.business ? 'Business suspended' : 'Specialist suspended'
    end
  end

  def active_for_authentication?
    super && !suspended? && !deleted? # Extra safeguard, default_scope should prevent deleted users from being found
  end

  def create_privacy_agreement(ip_address, status)
    tos_agreement.create(
      # tos_description: tos,
      # cookie_description: cookie,
      status: status,
      agreement_date: Time.zone.now,
      ip_address: ip_address
    )
  end

  def update_privacy_agreement(ip_address)
    tos_agreement.update(
      agreement_date: Time.zone.now,
      ip_address: ip_address
    )
  end

  def create_privacy_agreements(ip_address, params)
    create_tos_agreement(ip_address, params[:tos_description])
  end
end

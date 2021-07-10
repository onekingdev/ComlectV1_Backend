# frozen_string_literal: true

require 'validators/email_validator'
require 'otp/mailer'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
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
  has_one :cookie_agreement, dependent: :destroy

  validates :email, presence: true
  validates :email, email: true, if: :email_present?

  delegate :present?, to: :email, prefix: true

  accepts_nested_attributes_for :tos_agreement
  accepts_nested_attributes_for :cookie_agreement

  scope :inactive, -> {
    where('last_sign_in_at < ?', Time.zone.now - 90.days)
      .where(inactive_for_period: false, suspended: false)
  }

  default_scope -> { where(deleted: false) }

  serialize :muted_projects

  OTP_DIGITS = 6
  include OTP::ActiveRecord

  def email_otp
    OTP::Mailer.otp(email, otp, self).deliver
  end

  def verify_otp(otp)
    return nil if !valid? || !persisted? || otp_secret.blank?

    otp_digits = self.class.const_get(:OTP_DIGITS)
    hotp = ROTP::HOTP.new(otp_secret, digits: otp_digits)
    transaction do
      otp_status = hotp.verify(otp.to_s, otp_counter)
      otp_status
    end
  end

  def business_or_specialist
    business || specialist
  end

  def upvotes
    # forum_votes.where(upvote: true)
    ForumVote.where(upvote: true, forum_answer_id: forum_answers.collect(&:id)).count
  end

  def photo(*args, &block)
    business ? business.logo(*args, &block) : specialist.photo(*args, &block)
  end

  def photo_url(*args, &block)
    business ? business.logo_url(*args, &block) : specialist.photo_url(*args, &block)
  end

  def full_name
    if specialist
      [specialist.first_name, specialist.last_name].join(' ')
    else
      [business.contact_first_name, business.contact_last_name].join(' ')
    end
  end

  def short_name
    if specialist
      [specialist.first_name.capitalize, specialist.last_name.capitalize.first].join(' ') + '.'
    elsif business.anonymous?
      'Anonymous'
    else
      business.business_name
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

  def create_cookie_agreement(ip_address, status, description)
    CookieAgreement.create(
      user: self,
      cookie_description: description,
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

  def update_cookie_agreement(ip_address)
    cookie_agreement.update(
      agreement_date: Time.zone.now,
      ip_address: ip_address
    )
  end

  def hide_local_project(project_id)
    update(hidden_local_projects: (hidden_local_projects | [project_id]))
  end

  def show_local_project(project_id)
    update(hidden_local_projects: (hidden_local_projects - [project_id]))
  end

  def send_confirmation_notification?
    false
  end
end

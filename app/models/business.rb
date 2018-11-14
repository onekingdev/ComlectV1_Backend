# frozen_string_literal: true

require 'validators/url_validator'

class Business < ApplicationRecord
  belongs_to :user

  belongs_to :rewards_tier
  belongs_to :rewards_tier_override, class_name: 'RewardsTier'

  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :industries
  has_many :projects, dependent: :destroy
  has_many :job_applications, through: :projects
  has_many :charges, through: :projects
  has_many :transactions, through: :projects
  has_one :payment_profile, dependent: :destroy
  has_many :payment_sources, through: :payment_profile
  has_many :project_invites, dependent: :destroy
  has_many :favorites, as: :owner
  has_many :favorited_by, as: :favorited, dependent: :destroy, class_name: 'Favorite'
  has_many :favorite_specialists, through: :favorites, source: :favorited, source_type: 'Specialist'
  has_many :hired_specialists, -> { distinct }, through: :projects, source: :specialist
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :ratings_received, -> {
    where(rater_type: Specialist.name).order(created_at: :desc)
  }, through: :projects, source: :ratings
  has_many :email_threads, dependent: :destroy

  has_one :referral, as: :referrable
  has_many :referral_tokens, as: :referrer

  has_settings do |s|
    s.key :notifications, defaults: {
      marketing_emails: true,
      got_rated: true,
      project_ended: true,
      got_message: true
    }
  end

  alias communicable_projects projects

  default_scope -> { joins("INNER JOIN users ON users.id = businesses.user_id AND users.deleted = 'f'") }

  include ImageUploader[:logo]

  EMPLOYEE_OPTIONS = %w[<10 11-50 51-100 100+].freeze

  validates :contact_first_name, :contact_last_name, :contact_email, presence: true
  validates :business_name, :industries, :employees, :description, presence: true
  validates :country, :city, :state, :time_zone, presence: true
  validates :description, length: { maximum: 750 }
  validates :employees, inclusion: { in: EMPLOYEE_OPTIONS }
  validates :linkedin_link, allow_blank: true, url: true
  validates :website, allow_blank: true, url: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  accepts_nested_attributes_for :user

  delegate :suspended?, to: :user

  after_commit :sync_with_hubspot, on: %i[create update]
  after_commit :generate_referral_token, on: :create

  after_create :sync_with_mailchimp

  def self.for_signup(attributes = {}, token = nil)
    new(attributes).tap do |business|
      business.build_user unless business.user
      referral_token = ReferralToken.find_by(token: token) if token
      business.build_referral(referral_token: referral_token) if referral_token
    end
  end

  def referral_token
    referral_tokens.last
  end

  def available_projects
    projects
  end

  def in_usa?
    country == 'US'
  end

  def tz
    ActiveSupport::TimeZone[time_zone.to_s] || Time.zone
  end

  def messages
    Message.where("
      (recipient_type = '#{Business.name}' AND recipient_id = :id) OR
      (sender_type = '#{Business.name}' AND sender_id = :id)", id: id)
  end

  def to_s
    business_name
  end

  def public?
    !anonymous?
  end

  def contact_full_name
    [contact_first_name, contact_last_name].map(&:presence).compact.join(' ')
  end

  def processed_transactions_amount
    year = Time.zone.now.in_time_zone(tz).year
    transactions.processed.by_year(year).map(&:subtotal).inject(&:+) || 0
  end

  alias original_rewards_tier rewards_tier
  def rewards_tier
    return RewardsTier.default unless original_rewards_tier
    return rewards_tier_override if rewards_tier_override_precedence?
    original_rewards_tier
  end

  def rewards_tier_override_precedence?
    return false unless rewards_tier_override
    rewards_tier_override.fee_percentage < original_rewards_tier.fee_percentage
  end

  def sync_with_hubspot
    SyncHubspotContactJob.perform_later(self)
  end

  def generate_referral_token
    GenerateReferralTokensJob.perform_later(self)
  end

  def sync_with_mailchimp
    SyncBusinessUsersToMailchimpJob.perform_later(self)
  end
end

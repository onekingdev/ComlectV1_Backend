# frozen_string_literal: true

require 'validators/url_validator'
# rubocop:disable Metrics/ClassLength

class Business < ApplicationRecord
  belongs_to :user

  belongs_to :rewards_tier
  belongs_to :rewards_tier_override, class_name: 'RewardsTier'

  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :industries
  has_many :forum_questions
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
  has_many :compliance_policies

  has_one :forum_subscription
  has_one :tos_agreement, through: :user
  has_one :cookie_agreement, through: :user

  has_one :referral, as: :referrable
  has_many :referral_tokens, as: :referrer

  has_settings do |s|
    s.key :notifications, defaults: {
      marketing_emails: true,
      got_rated: true,
      project_ended: true,
      got_message: true,
      new_forum_answers: true,
      new_forum_comments: true
    }
  end

  serialize :sub_industries
  serialize :business_stages
  serialize :business_risks
  serialize :client_types
  serialize :already_covered
  serialize :cco

  STEP_THREE = [
    'startup', 'startup rescue', 'complete ongoing maintenance', 'one-off maintenance requests'
  ].freeze

  STEP_RISKS = [
    [
      'You head over and take a piece, because it worked out for the other two mice',
      'You think about it, but end up playing it safe',
      'You would have been on that cheese the moment you saw it',
      'You need to do more research and want to see if more mice are succesful',
      'No, thank you! Risk death? Not worth it.'
    ],
    [
      'Slow down to the speed limit in case it’s a cop ',
      'Moderate your speed to the flow of traffic ',
      'You’d never speed ',
      'Hope for the best, because you can’t afford to be late to this meeting',
      'You always speed, even if cops are around, because they have to catch you first'
    ],
    [
      'To win big, you sometimes have to take big risks',
      'Measure twice, cut once',
      'My belief in a day of reckoning keeps me on the straight and narrow',
      'There’s a fine line between taking a calculated risk and doing something dumb',
      'The biggest risk is not taking any risk'
    ]
  ].freeze

  # rubocop:disable Metrics/LineLength
  QUIZ = [
    [:sec_or_crd],
    [:office_state],
    [:branch_offices],
    [:client_account_cnt],
    [:client_types, %i[less_1mm accredited_investors qualified_purchasers institutional_investors pooled_investment]],
    [:aum],
    [:cco, %i[yes no dedicated]],
    [:already_covered, %i[code_of_ethics privacy custody portfolio trading proxy valuation marketing regulatory books planning compliance other]],
    [:review_plan, %i[no basic deluxe premium]],
    [:annual_compliance, %i[yes no]],
    [:finish]
  ].freeze
  # rubocop:enable Metrics/LineLength

  # rubocop:disable Metrics/AbcSize
  def apply_quiz(cookies)
    step1_c = cookies[:complect_step1].split('-').map(&:to_i)
    self.sub_industries = []
    cookies[:complect_step11].split('-').map(&proc { |p| p.split('_').map(&:to_i) }).each do |c|
      sub_industries.push(Industry.find(c[0]).sub_industries.split("\r\n")[c[1]]) if step1_c.include? c[0]
    end
    self.business_stages = []
    cookies[:complect_step3].split('-').map(&:to_i).each { |c| business_stages.push(STEP_THREE[c]) }
    self.business_risks = []
    business_risks[0] = STEP_RISKS[0][cookies[:complect_step4].to_i]
    business_risks[1] = STEP_RISKS[1][cookies[:complect_step41].to_i]
    business_risks[2] = STEP_RISKS[2][cookies[:complect_step42].to_i]
    self.business_other = cookies[:complect_other] if industries.collect(&:name).include? 'Other'
  end
  # rubocop:enable Metrics/AbcSize

  alias communicable_projects projects

  default_scope -> { joins("INNER JOIN users ON users.id = businesses.user_id AND users.deleted = 'f'") }

  include ImageUploader[:logo]

  EMPLOYEE_OPTIONS = %w[<10 11-50 51-100 100+].freeze

  validates :contact_first_name, :contact_last_name, presence: true
  validates :business_name, :industries, :employees, presence: true
  validates :country, :city, :state, :time_zone, presence: true
  validates :description, length: { maximum: 750 }
  validates :employees, inclusion: { in: EMPLOYEE_OPTIONS }
  validates :linkedin_link, allow_blank: true, url: true
  validates :website, allow_blank: true, url: true
  # validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, uniqueness: true

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :tos_agreement
  accepts_nested_attributes_for :cookie_agreement

  validate :tos_invalid?
  validate :cookie_agreement_invalid?

  delegate :suspended?, to: :user

  after_commit :sync_with_hubspot, on: %i[create update]
  after_commit :generate_referral_token, on: :create

  after_create :sync_with_mailchimp

  def self.for_signup(attributes = {}, token = nil)
    new(attributes).tap do |business|
      business.build_user.build_tos_agreement unless business.user
      business.build_cookie_agreement unless business.user
      referral_token = ReferralToken.find_by(token: token) if token
      business.build_referral(referral_token: referral_token) if referral_token
    end
  end

  def to_param
    username
  end

  def state_or_sec
    if aum.nil? || (!aum.nil? && (aum < 100_000_000)) || only_pooled_investment?
      'state'
    else
      'sec'
    end
  end

  def personalized?
    current_question = 0
    quiz_copy = QUIZ.dup
    unless business_stages.nil?
      quiz_copy -= %i[sec_or_crd already_covered annual_compliance] if business_stages.include? 'startup'
      quiz_copy.each_with_index do |q, i|
        current_question = i
        break if q[0] == :finish || __send__(q[0]).nil?
      end
    end
    quiz_copy[current_question][0] == :finish
  end

  def only_pooled_investment?
    (!client_types.nil? && (client_types - ['pooled_investment']).count.zero?)
  end

  def pooled_investment?
    (!client_types.nil? && (client_types.include? 'pooled_investment'))
  end

  # rubocop:disable all
  def gap_analysis_est
    basic = 450
    deluxe = 1000
    premium = 2000
    employees_cnt = employees.scan(/\d/).join('').to_i
    # SMALL
    if state_or_sec == 'state'
      if employees_cnt > 2
        basic = 450
        deluxe = 1250
        premium = 2250
      else
        basic = 450
        deluxe = 1000
        premium = 2000
      end
    end
    # MID
    if state_or_sec == 'sec'
      if !pooled_investment? && !client_account_cnt.nil? && (client_account_cnt > 500)
        if employees_cnt <= 10
          basic = 500
          deluxe = 1500
          premium = 2750
        end
        if (employees_cnt > 10) && (employees_cnt <= 50)
          basic = 1000
          deluxe = 2750
          premium = 4500
        end
      end
      if pooled_investment? && !aum.nil?
        if aum < 500_000_000
          basic = 2000
          deluxe = 4500
          premium = 7500
        end
        if aum >= 500_000_000
          basic = 3500
          deluxe = 6500
          premium = 11_500
        end
      end
      # LARGE
      if !aum.nil? && (aum >= 1_000_000_000)
        if !pooled_investment? && !client_account_cnt.nil? && (client_account_cnt > 500)
          basic = 1450
          deluxe = 4500
          premium = 8250
        end
        if pooled_investment?
          basic = 7500
          deluxe = 8500
          premium = 35_500
        end
      end
    end
    [basic, deluxe, premium]
  end
  # rubocop:enable all

  def generate_username
    src = business_name.split(' ').map(&:capitalize).join('')
    generated = src.delete(' ').gsub(/[^0-9a-z ]/i, '')
    while Business.where(username: generated).count.positive?
      ext_num = generated.scan(/\d/).join('')
      generated = if !ext_num.empty?
                    "#{src}#{ext_num.to_i + 1}"
                  else
                    "#{src}1"
                  end
    end
    generated
  end

  def tos_invalid?
    errors.add(:tos_agree, 'You must agree to the terms of service to create an account') unless user.tos_agreement&.status
  end

  def cookie_agreement_invalid?
    errors.add(:cookie_agree, 'You must agree to cookies to create an account') unless user.cookie_agreement&.status
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
    # For dev testing and triggering heroku deploy
    # SyncBusinessUsersToMailchimpJob.perform_now(self)
  end

  def subscription?
    if forum_subscription && !forum_subscription.suspended
      forum_subscription[:level]
    else
      0
    end
  end
end
# rubocop:enable Metrics/ClassLength

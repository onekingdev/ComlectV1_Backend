# frozen_string_literal: true
class PaymentSource < ActiveRecord::Base
  belongs_to :payment_profile
  has_many :charges

  scope :sorted, -> { order('"primary" DESC, type DESC, created_at DESC') }

  before_create :create_source
  after_destroy :delete_stripe_data

  attr_accessor :token

  class << self
    def plaid_or_manual(business, params)
      add_to business, params
    end

    private

    def add_to_existing(profile, token)
      source = profile.payment_sources.new token: token, validated: true, primary: profile.payment_sources.empty?
      source.save if profile.errors.empty?
      source
    rescue Stripe::StripeError => e
      source.errors.add :base, e.message
      source
    end

    def create_profile_and_add(business, token)
      profile = business.create_payment_profile
      add_to_existing profile, token
    end
  end

  def self.add_to(business, token)
    if business.payment_profile
      add_to_existing business.payment_profile, token
    else
      create_profile_and_add business, token
    end
  end

  def update_from_stripe(token)
    delete_stripe_data
    self.token = token
    self.primary = primary || payment_profile.payment_sources.count <= 1
    create_source
    save
  end

  def make_primary!
    stripe_customer.default_source = stripe_id
    stripe_customer.save
    payment_profile.payment_sources.update_all primary: false
    update_attribute :primary, true
  end

  def bank_account?
    false
  end

  private

  STRIPE_CARD_KEYS = %i(brand exp_month exp_year last4).freeze

  def create_source
    source = stripe_customer.sources.create(source: token)
    self.attributes = source.to_h.slice(*STRIPE_CARD_KEYS)
    self.stripe_id = source['id']
    if primary?
      stripe_customer.default_source = source['id']
      stripe_customer.save
    end
    true
  rescue Stripe::StripeError => e
    errors.add :base, e.message
  end

  def stripe_customer
    @_stripe_customer ||= payment_profile.stripe_customer
  end

  def delete_stripe_data
    if stripe_id.present?
      source = stripe_customer.sources.retrieve stripe_id
      source.delete
      payment_profile.update_default_source!
    end
  rescue => _e
    errors.add :base, 'Could not delete payment source'
    false
  else
    true
  end
end

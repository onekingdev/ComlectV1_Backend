# frozen_string_literal: true

module Stripe
  SUPPORTED_COUNTRIES = {
    AT: 'Austria',
    AU: 'Australia',
    BE: 'Belgium',
    CA: 'Canada',
    DE: 'Germany',
    DK: 'Denmark',
    ES: 'Spain',
    FI: 'Finland',
    FR: 'France',
    GB: 'United Kingdom',
    HK: 'Hong Kong',
    IE: 'Ireland',
    IT: 'Italy',
    JP: 'Japan',
    LU: 'Luxembourg',
    NL: 'Netherlands',
    NO: 'Norway',
    PT: 'Portugal',
    SE: 'Sweden',
    SG: 'Singapore',
    US: 'United States'
  }.freeze

  INDIVIDUAL_ONLY_COUNTRIES = %w[AT BE DE DK ES FI FR GB IE IT LU NL NO PT SE SG].freeze

  SUPPORTED_BANK_CURRENCIES = {
    AT: %w[EUR],
    BE: %w[EUR],
    AU: %w[AUD],
    CA: %w[CAD USD],
    DE: %w[EUR],
    DK: %w[EUR DKK],
    ES: %w[EUR],
    FI: %w[EUR],
    FR: %w[EUR],
    GB: %w[EUR GBP],
    HK: %w[HKD],
    IE: %w[EUR],
    IT: %w[EUR],
    JP: %w[JPY],
    LU: %w[EUR],
    NL: %w[EUR],
    NO: %w[EUR NOK],
    PT: %w[EUR],
    SE: %w[EUR SEK],
    SG: %w[SGD],
    US: %w[USD]
  }.freeze
end

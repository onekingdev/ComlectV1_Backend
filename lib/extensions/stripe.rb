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

  SUPPORTED_BANK_CURRENCIES = {
    AT: %w(EUR GBP USD DKK NOK SEK),
    BE: %w(EUR GBP USD DKK NOK SEK),
    AU: %w(AUD),
    CA: %w(CAD USD),
    DE: %w(EUR GBP USD DKK NOK SEK),
    DK: %w(EUR GBP USD DKK NOK SEK),
    ES: %w(EUR GBP USD DKK NOK SEK),
    FI: %w(EUR GBP USD DKK NOK SEK),
    FR: %w(EUR GBP USD DKK NOK SEK),
    GB: %w(EUR GBP USD DKK NOK SEK),
    HK: %w(HKD),
    IE: %w(EUR GBP USD DKK NOK SEK),
    IT: %w(EUR GBP USD DKK NOK SEK),
    JP: %w(JPY),
    LU: %w(EUR GBP USD DKK NOK SEK),
    NL: %w(EUR GBP USD DKK NOK SEK),
    NO: %w(EUR GBP USD DKK NOK SEK),
    PT: %w(EUR GBP USD DKK NOK SEK),
    SE: %w(EUR GBP USD DKK NOK SEK),
    SG: %w(SGD),
    US: %w(USD)
  }.freeze
end

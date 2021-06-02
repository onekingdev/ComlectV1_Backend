import { DateTime } from 'luxon'

const PRICING_TYPES = [{
  id: 'fixed',
  label: 'Fixed Price',
  text: 'Budget-friendly approach for scoped projects.'
}, {
  id: 'hourly',
  label: 'Hourly Price',
  text: 'Pay by the hour. Provides more flexibility.'
}]

const PRICING_TYPES_OPTIONS = Object.fromEntries(PRICING_TYPES.map(type => [type.id, type.label]))

const LOCATION_TYPES = {
  remote: 'Remote',
  remote_and_travel: 'Remote + Travel',
  onsite: 'Onsite'
}

const FIXED_PAYMENT_SCHEDULE_OPTIONS = {
  upfront: 'Upfront',
  fifty_fifty: '50/50',
  upon_completion: 'Upon Completion',
  bi_weekly: 'Bi-Weekly',
  monthly: 'Monthly'
}

const HOURLY_PAYMENT_SCHEDULE_OPTIONS = {
  upon_completion: 'Upon Completion',
  bi_weekly: 'Bi-Weekly',
  monthly: 'Monthly'
}

const SORT_INDUSTRIES = dbCollection => sortKnownOptions(dbCollection, INDUSTRY_OPTIONS_ORDER)
const SORT_JURISDICTIONS = dbCollection => sortKnownOptions(dbCollection, JURISDICTION_OPTIONS_ORDER)

const INDUSTRY_OPTIONS_ORDER = [
  'Investment Adviser',
  'Broker-Dealer',
  'Banking',
  'Commodities Trader',
  'Insurance Provider',
  'Fintech',
  'Other',
]

const JURISDICTION_OPTIONS_ORDER = [
  'USA',
  'Canada',
  'Europe',
  'Central America',
  'South America',
  'Australasia',
  'Asia',
  'Africa',
  'Caribbean',
  'Middle East',
]

const sortKnownOptions = (dbCollection, orderedNames)  => {
  const [sortableOptions, otherOptions] = dbCollection.reduce((result, option) => {
      result[orderedNames.includes(option.name) ? 0 : 1].push(option)
      return result
    }, [[], []])
  return sortableOptions
    .sort((a, b) => orderedNames.indexOf(a.name) - orderedNames.indexOf(b.name))
    .concat(otherOptions)
}

const FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED = (from, to) => filterPaymentScheduleOptions(FIXED_PAYMENT_SCHEDULE_OPTIONS, from, to)
const HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED = (from, to) => filterPaymentScheduleOptions(HOURLY_PAYMENT_SCHEDULE_OPTIONS, from, to)

const filterPaymentScheduleOptions = (options, dateFrom, dateTo) => {
  let maxDays = 1
  if (dateFrom && dateTo) {
    const from = DateTime.fromSQL(dateFrom), to = DateTime.fromSQL(dateTo)
    maxDays = from.isValid && to.isValid && to.diff(from, 'days').as('days') || 1
  }
  return Object.fromEntries(Object.entries(options)
    .filter(([key]) => ({ bi_weekly: 14, monthly: 30 }[key] || 0) < maxDays))
}

const MINIMUM_EXPERIENCE_OPTIONS = {
  0: "Junior",
  1: "Intermediate",
  2: "Expert"
}

const SPECIALIST_ROLE_OPTIONS = {
  'basic': 'Basic',
  'trusted': 'Trusted',
  'admin': 'Admin'
}

export {
  PRICING_TYPES,
  PRICING_TYPES_OPTIONS,
  LOCATION_TYPES,
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS,
  SORT_INDUSTRIES,
  SORT_JURISDICTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  MINIMUM_EXPERIENCE_OPTIONS,
  SPECIALIST_ROLE_OPTIONS,
}

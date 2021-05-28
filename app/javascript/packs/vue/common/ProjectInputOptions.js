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
  FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  MINIMUM_EXPERIENCE_OPTIONS,
  SPECIALIST_ROLE_OPTIONS,
}

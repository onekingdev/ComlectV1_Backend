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

const RFP_TIMING_OPTIONS = {
  asap: 'As soon as possible',
  two_weeks: 'Within the next 2 weeks',
  month: 'Within a month',
  not_sure: 'Not sure'
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

const MINIMUM_EXPERIENCE_OPTIONS = {
  0: "Junior",
  1: "Intermediate",
  2: "Expert"
}

export {
  PRICING_TYPES,
  PRICING_TYPES_OPTIONS,
  LOCATION_TYPES,
  RFP_TIMING_OPTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS,
  MINIMUM_EXPERIENCE_OPTIONS,
}

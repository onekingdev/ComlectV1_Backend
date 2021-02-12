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

const LOCATION_TYPES = [{
  value: 'remote',
  text: 'Remote'
}, {
  value: 'remote_and_travel',
  text: 'Remote + Travel'
}, {
  value: 'onsite',
  text: 'Onsite'
}]

const RFP_TIMING_OPTIONS = [{
  value: 'asap', text: 'As soon as possible',
},{
  value: 'two_weeks', text: 'Within the next 2 weeks',
},{
  value: 'month', text: 'Within a month',
},{
  value: 'not_sure', text: 'Not sure'
}]

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

export {
  PRICING_TYPES,
  PRICING_TYPES_OPTIONS,
  LOCATION_TYPES,
  RFP_TIMING_OPTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS,
}

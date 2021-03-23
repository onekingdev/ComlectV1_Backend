import {
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS
} from '@/common/ProjectInputOptions'

const fields = proposal => [
  { name: 'Start Date', value: proposal.starts_on, filter: 'asDate' },
  { name: 'Due Date', value: proposal.ends_on, filter: 'asDate' },
  {
    name: proposal.pricing_type === 'fixed' ? 'Bid Price' : 'Hourly Rate',
    value: proposal.pricing_type === 'fixed' ? proposal.fixed_budget : proposal.hourly_rate,
    filter: 'usdWhole'
  },
  { name: 'Payment Schedule', value: readablePaymentSchedule(proposal.payment_schedule) },
  { name: 'Role Details', value: proposal.role_details },
  { name: 'Key Deliverables', value: proposal.key_deliverables },
  { name: 'Attachments', value: '' },
]

const readablePaymentSchedule = value => ({
  ...FIXED_PAYMENT_SCHEDULE_OPTIONS,
  ...HOURLY_PAYMENT_SCHEDULE_OPTIONS
}[value])

export { readablePaymentSchedule, fields }

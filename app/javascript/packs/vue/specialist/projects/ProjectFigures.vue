<template lang="pug">
  ul.list-group.list-group-horizontal
    li.list-group-item(v-if="project.pricing_type === 'fixed'")
      | Fixed Budget
      br
      | {{ (project.est_budget || project.fixed_budget) | usdWhole }}
    li.list-group-item(v-else)
      | Hourly
      br
      | {{ project.hourly_rate | usdWhole }} - {{ project.upper_hourly_rate | usdWhole }}
    li.list-group-item
      | Payment Schedule
      br
      | {{ paymentScheduleReadable }}
    li.list-group-item
      | Jurisdiction
      br
      | {{ project.jurisdictions | names }}
</template>

<script>
import { FIXED_PAYMENT_SCHEDULE_OPTIONS } from '@/common/ProjectInputOptions'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    paymentScheduleReadable() {
      return FIXED_PAYMENT_SCHEDULE_OPTIONS[this.project.payment_schedule]
    }
  }
}
</script>
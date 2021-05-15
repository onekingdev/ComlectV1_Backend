<template lang="pug">
  ul.list-group.list-group-horizontal.w-100.project-figures
    li.list-group-item(v-if="project.pricing_type === 'fixed'")
      ion-icon.float-left.mt-3.mr-3(name="cash-outline")
      | Estimated Budget
      br
      b {{ project.est_budget | usdWhole }}
    li.list-group-item(v-else)
      ion-icon.float-left.mt-3.mr-3(name="cash-outline")
      | Hourly
      br
      b {{ project.hourly_rate | usdWhole }} - {{ project.upper_hourly_rate | usdWhole }}
    li.list-group-item
      ion-icon.float-left.mt-3.mr-3(name="cash-outline")
      | Payment Schedule
      br
      b {{ paymentScheduleReadable }}
    li.list-group-item
      ion-icon.float-left.mt-3.mr-3(name="earth-outline")
      | Jurisdiction
      br
      b {{ project.jurisdictions | names }}
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
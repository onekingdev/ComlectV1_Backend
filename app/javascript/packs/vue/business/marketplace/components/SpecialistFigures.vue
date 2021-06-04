<template lang="pug">
  ul.list-group.list-group-horizontal.w-100.project-figures.specialist-figures
    li.list-group-item
      ion-icon.float-left.mt-3.mr-3(name="cash-outline")
      | Hourly rate
      br
      b ${{ specialist.min_hourly_rate | usdWhole }} - {{ specialist.upper_hourly_rate | usdWhole }}
    li.list-group-item
      ion-icon.float-left.mt-3.mr-3(name="analytics-outline")
      | Expirience
      br
      b {{ experienceOptions[specialist.experience] }}
    li.list-group-item
      ion-icon.float-left.mt-3.mr-3(name="earth-outline")
      | Jurisdiction
      br
      b {{ specialist.jurisdictions | names }}
</template>

<script>
import { FIXED_PAYMENT_SCHEDULE_OPTIONS, MINIMUM_EXPERIENCE_OPTIONS } from '@/common/ProjectInputOptions'

export default {
  props: {
    specialist: {
      type: Object,
      required: true
    }
  },
  computed: {
    paymentScheduleReadable() {
      return FIXED_PAYMENT_SCHEDULE_OPTIONS[this.specialist.payment_schedule]
    },
    experienceOptions() {
      return MINIMUM_EXPERIENCE_OPTIONS
    }
  }
}
</script>

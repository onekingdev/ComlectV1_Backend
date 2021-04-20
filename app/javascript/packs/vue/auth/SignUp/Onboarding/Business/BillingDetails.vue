<template lang="pug">
  div.position-relative
    .card-header
      .row
        .col
          h4 Plan
        .col.text-right
          b-form-group(v-slot="{ ariaDescribedby }")
            b-form-radio-group(id="btn-radios-plan"
            v-model="billingTypeSelected"
            :options="billingTypeOptions"
            :aria-describedby="ariaDescribedby"
            button-variant="outline-primary"
            size="lg"
            name="radio-btn-outline"
            buttons)
    .card-header
      .row
        .col
          h4.m-t-1 {{ planComputed.name }}
          p {{ planComputed.description }}
        .col.text-right
          h4 {{ planComputed.coast }}
          p {{ planComputed.users }}
    .card-header
      .d-flex.justify-content-between
        div
          h4.m-t-1 Users
          p Enter the amount of applicable employees to join your plan
        dl.row.m-t-2
          dt.col-sm-3
          dd.col-sm-9
            b-form-group
              b-form-input(v-model="planComputed.usersCount" type="number" min="1" max="100")
    .card-header
      .d-flex.justify-content-between
        h4.m-t-1 Payment Method
        div
          a.btn.btn-light Add Bank Account
    //PurchaseSummary

</template>

<script>
import PurchaseSummary from './PurchaseSummary'
export default {
  props: ['billingTypeSelected', 'billingTypeOptions', 'plan'],
  components: {
    PurchaseSummary,
  },
  computed: {
    planComputed() {
      return this.plan
    }
  }
}
</script>

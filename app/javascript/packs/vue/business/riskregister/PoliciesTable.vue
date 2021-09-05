<template lang="pug">
  div
    table.table(v-if="riskPolicies.length !== 0")
      thead
        tr
          th(width="55%") Policy
          th Status
            b-icon.ml-2(icon='chevron-expand')
          th.text-right Last modified
            b-icon.ml-2(icon='chevron-expand')
          th.text-right Date created
            b-icon.ml-2(icon='chevron-expand')
          th(width="10%")
      tbody
        tr(v-for="policy in riskPolicies" :key="policy.id")
          td
            a.link.custom-text(:href="`/business/compliance_policies/${policy.id}`")
              img.icon-policy(src='@/assets/policy.svg')
              | {{ policy.name }}
          td
            b-badge.status(:variant="statusVariant" :class="{ 'status__published': policy.status === 'published'}") {{ policy.status }}
          td.text-right {{ dateToHuman(policy.updated_at) }}
          td.text-right {{ dateToHuman(policy.created_at) }}
          td.text-right
            .actions
              b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                template(#button-content)
                  b-icon.three-dots(icon="three-dots")
                <!--b-dropdown-item-button Edit-->
                b-dropdown-item-button.delete(@click="deleteControl(policy.id)") Delete
</template>

<script>
  import { DateTime } from 'luxon'

  export default {
    props: ['riskPolicies'],
    data() {
      return {
        statusVariant: 'light',
      }
    },
    methods: {
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('dd/MM/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      deleteControl(policyId) {
        this.$emit('deleteControl', policyId)
      },
    },
    computed: {

    },
    watch: {},
  }
</script>

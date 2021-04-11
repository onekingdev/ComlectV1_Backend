<template lang="pug">
  div.d-inline-block
    div.d-inline-block(v-b-modal="modalId"): slot
    b-modal.fade(:id="modalId" title="End Contract")
      p ℹ️ Ending this contract will remove this specialist as a collaborator to the project, revoke and permissions granted due to the project, and payout the full contract price.
      p: b Do you want to continue?
      .card
        .card-header
          .row
            .col-sm
              img.m-r-1.userpic_small(v-if="project.specialist.photo" :src="project.specialist.photo")
              h3 {{ project.specialist.first_name }} {{project.specialist.last_name }}
              p Specialist
            .col-sm
              span.float-right Outstanding Due <br> {{ 500 | usdWhole }}
        .card-header
          p
            b Project name
            span.float-right {{ project.title }}
          p
            b Payment method
            span.float-right {{ readablePaymentSchedule(project.payment_schedule) }}
          p
            b Date Issued
            span.float-right
          p
            b Payment Method
            span.float-right Transfer to Visa
        .card-header
          p.text-right.text-muted *Transactional fees lorem ipsum dolor.
      template(slot="modal-footer")
        button.btn(@click="close") Cancel
        Post(:action="completeUrl" :model="{}" @saved="close(), $emit('saved')" @errors="$emit('errors', $event)")
          button.btn.btn-dark.m-r-1 Confirm
</template>

<script>
import { readablePaymentSchedule } from '@/common/ProposalFields'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return { modalId: 'EndContactModal_' + Math.random().toFixed(12).replace('.', '') }
  },
  methods: {
    readablePaymentSchedule,
    close() {
      this.$bvModal.hide(this.modalId)
    }
  },
  computed: {
    completeUrl() {
      return '/api/projects/' + this.project.id + '/end'
    }
  }
}
</script>
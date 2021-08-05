<template lang="pug">
  div
    button.btn.btn-default(v-b-modal="'ApproveContractChangesModal'") View
    b-modal(id="ApproveContractChangesModal" title="View Changes")
      .row
        .col-md-12
          h3 Terms
          .row
            .col-sm
              label.form-label Start Date
              input.form-control-plaintext(type="text" readonly :value="extension.starts_on | asDate" :class="inputClass('starts_on')")
            .col-sm
              label.form-label Due Date
              input.form-control-plaintext(type="text" readonly :value="extension.ends_on | asDate" :class="inputClass('ends_on')")
          div(v-if="extension.hourly_rate == null")
            label.form-label Fixed Budget
            input.form-control-plaintext(type="text" readonly :value="extension.fixed_budget | usdWhole" :class="inputClass('fixed_budget')")
          div(v-else)
            label.form-label Hourly Rate
            input.form-control-plaintext(type="text" readonly :value="extension.hourly_rate | usdWhole" :class="inputClass('hourly_rate')")
          hr
          h3 Role
          label.form-label Role Details
          textarea.form-control-plaintext(readonly :value="extension.role_details" :class="inputClass('role_details')" rows="4")
          label.form-label Key Deliverables
          textarea.form-control-plaintext(readonly :value="extension.key_deliverables" :class="inputClass('key_deliverables')" rows="4")
          h3.m-t-1 Attachments
          .card.m-b-1
            .card-body
      template(#modal-footer="{ hide }")
        a.m-r-1.btn(@click="hide") Cancel
        Post(:action="`/api/projects/${project.id}/extension/1`" method="PUT" :model="{deny:true}" @saved="saved(false)")
          button.btn.btn-outline-dark Reject
        Post(:action="`/api/projects/${project.id}/extension/1`" method="PUT" :model="{confirm:true}" @saved="saved(true)")
          button.btn.btn-dark Accept
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  methods: {
    saved(isAccepted) {
      this.toast('Success', isAccepted ? 'Accepted' : 'Rejected')
      this.$bvModal.hide('ApproveContractChangesModal')
      this.$emit('saved')
    },
    inputClass(property) {
      const differs = property => this.project[property] && this.project.extension[property] &&
                                  this.project[property] != this.project.extension[property]
      return differs(property) ? 'border border-warning' : ''
    }
  },
  computed: {
    extension() {
      return this.project.extension
    }
  }
}
</script>
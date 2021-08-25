<template lang="pug">
  b-modal.fade#DenyProposalConfirm(title="Reject Proposal")
    .row
      .col-sm-2
        b-icon.m-1(icon="exclamation-triangle-fill" scale="2" variant="danger")
      .col-sm
        p You are rejecting the terms of this proposal. The specialist will be notified and removed from your applicant pool.
        p: strong Do you want to continue?
    template(#modal-footer="{ hide }")
      button.btn.btn-outline-dark(@click="$emit('back')") Go Back
      Post(:action="denyUrl" :model="{}" @saved="$emit('denied', application.project.local_project_id)")
        button.btn.btn-dark Confirm
</template>

<script>
export default {
  props: {
    application: {
      type: Object,
      required: true
    },
    projectId: {
      type: Number,
      required: true
    }
  },
  computed: {
    denyUrl() {
      return `/api/business/projects/${this.projectId}/applications/${this.application.id}/hide`
    }
  }
}
</script>
<template lang="pug">
  div(v-if="isVisible || hasUpdate")
    .alert.alert-info(v-if="hasUpdate")
      h4.alert-heading Project update requested.
      p Waiting for business to accept or decline.
    .alert.alert-warning(v-if="isVisible && project.extension.ends_on_only")
      h4.alert-heading {{ project.business.business_name }} has requested to extend the deadline to {{ project.extension.ends_on | asDate }}
      p
        Post(:action="apiUrl" method="PUT" :model="{confirm:true}" @saved="saved(true)")
          button.btn.btn-default.float-right Accept
        Post(:action="apiUrl" method="PUT" :model="{deny:true}" @saved="saved(false)")
          button.btn.btn-default.float-right.m-r-1 Deny
        | Would you like to proceed?
    .alert.alert-warning(v-else-if="isVisible")
      h4.alert-heading Contract change requested
      p
        | Would you like to proceed?
        ApproveContractChangesModal(:project="project" @saved="$emit('saved')")
</template>

<script>
import ApproveContractChangesModal from '@/common/projects/ApproveContractChangesModal'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  methods: {
    saved(isAccepted) {
      this.toast('Success', isAccepted ? 'Deadline extended' : 'Deadline extension denied')
      this.$emit('saved')
    }
  },
  computed: {
    hasUpdate() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith('Specialist')
    },
    isVisible() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith('Business')
    },
    apiUrl() {
      return '/api/projects/' + this.project.id + '/extension/' + 1
    }
  },
  components: {
    ApproveContractChangesModal
  }
}
</script>
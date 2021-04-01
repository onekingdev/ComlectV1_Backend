<template lang="pug">
  div(v-if="isVisible")
    .alert.alert-warning(v-if="project.extension.ends_on_only")
      h4.alert-heading {{ project.business.business_name }} has requested to extend the deadline to {{ project.extension.ends_on | asDate }}
      p
        Post(:action="apiUrl" method="PUT" :model="{confirm:true}" @saved="saved(true)")
          button.btn.btn-default.float-right Accept
        Post(:action="apiUrl" method="PUT" :model="{deny:true}" @saved="saved(false)")
          button.btn.btn-default.float-right.m-r-1 Deny
        | Would you like to proceed?
    .alert.alert-warning(v-else)
      h4.alert-heading Contract change requested
      p
        | Would you like to proceed?
        ApproveContractChangesModal(:project="project")
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
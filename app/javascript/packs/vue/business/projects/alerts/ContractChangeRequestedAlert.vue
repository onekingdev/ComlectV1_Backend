<template lang="pug">
  .alert.alert-warning(v-if="isVisible")
    h4.alert-heading Contract change requested
    p.d-flex.justify-content-between
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
  computed: {
    isVisible() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith('Specialist')
    }
  },
  components: {
    ApproveContractChangesModal
  }
}
</script>
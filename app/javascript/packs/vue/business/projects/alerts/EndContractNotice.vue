<template lang="pug">
  .alert.alert-info(v-if="project.end_request")
    h4.alert-heading Project End
    div(v-if="project.end_request.requester.startsWith('Specialist')")
      p The specialist requested project end
      EndContractModal(:project="project" @saved="$emit('saved')" @errors="$emit('errors', $event)" :right="false")
        button.btn.btn-light Confirm
      button.btn.btn-light.m-l-1 Deny
    div(v-else)
      p You have requested project end
</template>

<script>
import EndContractModal from '../EndContractModal'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    url() {
      return '/api/business/projects/' + this.project.id + '/ends/' + this.project.end_request.id
    }
  },
  components: {
    EndContractModal
  }
}
</script>
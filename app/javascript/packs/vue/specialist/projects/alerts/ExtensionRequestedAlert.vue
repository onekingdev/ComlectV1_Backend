<template lang="pug">
  .alert.alert-warning(v-if="isVisible")
    h4.alert-heading {{ project.business.business_name }} has requested to extend the deadline to {{ project.extension.ends_on | asDate }}
    p
      Post(:action="apiUrl" method="PUT" :model="{confirm:true}" @saved="toast('Accepted', 'Yes'), $emit('saved')")
        button.btn.btn-default.float-right Accept
      Post(:action="apiUrl" method="PUT" :model="{deny:true}" @saved="toast('Denied', 'Da'), $emit('saved')")
        button.btn.btn-default.float-right.m-r-1 Deny
      | Would you like to proceed?
      EditContractModal(:project-id="project.id" :is-specialist="true")
        button.btn.btn-outline-dark.float-right View
</template>

<script>
import EditContractModal from '@/business/projects/EditContractModal'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    isVisible() {
      return this.project.extension
    },
    apiUrl() {
      return '/api/projects/' + this.project.id + '/extension'
    }
  },
  components: {
    EditContractModal
  }
}
</script>
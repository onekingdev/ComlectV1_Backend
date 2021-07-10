<template lang="pug">
  .container.white-card-body
    .row.p-x-1
      .col-md-12.p-t-3.p-b-1
        Wizard(v-bind="{projectId, industryIds, jurisdictionIds, localProject}")
</template>

<script>
import Wizard from './PostProjectWizard'

export default {
  props: {
    projectId: {
      type: Number
    },
    industryIds: {
      type: Array,
      required: true
    },
    jurisdictionIds: {
      type: Array,
      required: true
    },
    localProject: {
      type: Object
    }
  },
  components: {
    Wizard
  }
}
</script>
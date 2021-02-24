<template lang="pug">
  .container
    .row.p-x-1
      .col-md-12.p-t-3.p-b-1
        Breadcrumbs(:items="breadcrumbs")
        Wizard(v-bind="{industryIds,jurisdictionIds,localProjectId}")
</template>

<script>
import Wizard from './PostProjectWizard'

export default {
  props: {
    industryIds: {
      type: Array,
      required: true
    },
    jurisdictionIds: {
      type: Array,
      required: true
    },
    localProjectId: {
      type: Number
    }
  },
  components: {
    Wizard
  },
  computed: {
    breadcrumbs: () => ['Projects', 'Post Project']
  }
}
</script>
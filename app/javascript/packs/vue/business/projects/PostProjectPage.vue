<template lang="pug">
  .container.white-card-body
    .row.p-x-1
      .col-md-12.p-t-3.p-b-1
        Breadcrumbs(:items="breadcrumbs")
        Wizard(v-bind="{industryIds,jurisdictionIds,localProject}")
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
    localProject: {
      type: Object
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
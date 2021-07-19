<template lang="pug">
  .container.white-card-body
    Get(staticCollections="/api/static_collection" :localProject="localProjectUrl")
      template(v-slot="{ staticCollections: { industries: industryIds, jurisdictions: jurisdictionIds }, localProject }")
        .row.p-x-1
          .col-md-12.p-t-3.p-b-1
            Wizard(v-bind="{ projectId, industryIds, jurisdictionIds, localProject }")
</template>

<script>
import Wizard from './PostProjectWizard'

export default {
  props: {
    projectId: {
      type: Number
    },
    localProjectId: {
      type: Number
    }
  },
  components: {
    Wizard
  },
  computed: {
    localProjectUrl() {
      return this.localProjectId && `/api/business/local_projects/${this.localProjectId}`
    }
  }
}
</script>
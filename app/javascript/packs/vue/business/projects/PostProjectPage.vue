<template lang="pug">
  .page.bg-white
    Get(staticCollections="/api/static_collection" :localProject="localProjectUrl")
      template(v-slot="{ staticCollections: { industries: industryIds, jurisdictions: jurisdictionIds }, localProject }")
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

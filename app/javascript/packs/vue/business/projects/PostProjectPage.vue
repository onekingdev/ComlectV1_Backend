<template lang="pug">
  .container
    .row.p-x-1
      .col-md-12.p-t-3.p-b-1
        Breadcrumbs(:items="breadcrumbs")
        Wizard
</template>

<script>
import Wizard from './PostProjectWizard'

export default {
  components: {
    Wizard
  },
  computed: {
    breadcrumbs: () => ['Projects', 'Post Project']
  }
}
</script>
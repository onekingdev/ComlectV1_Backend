<template lang="pug">
  div
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
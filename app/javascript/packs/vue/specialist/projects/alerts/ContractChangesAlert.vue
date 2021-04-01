<template lang="pug">
  .alert.alert-info(v-if="hasUpdate")
    h4.alert-heading Project update requested.
    p Waiting for business to accept or decline.
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    hasUpdate() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith('Business')
    }
  }
}
</script>
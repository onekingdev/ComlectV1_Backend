<template>
  <div>{{projectView}}</div>
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
    projectView() {
      return this.project
    }
  }
}
</script>
<template lang="pug">
  div
    Breadcrumbs(:items="['Projects', project.title]")
    h2 {{ project.title }}
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  }
}
</script>
<template lang="pug">
  Post(
    v-bind="{ action, model, headers }"
    method="PUT"
    @errors="$emit('errors', $event)"
    @saved="$emit('saved')"
  ): slot
</template>

<script>
export default {
  props: {
    action: {
      type: String,
      required: true
    },
    model: {
      type: Object,
      required: true
    },
    headers: {
      type: Object,
      default: () => ({})
    }
  }
}
</script>
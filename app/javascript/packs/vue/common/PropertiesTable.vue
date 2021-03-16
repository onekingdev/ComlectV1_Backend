<template lang="pug">
  .card
    .card-header: h3 {{ title }}
    .card-body
      .row(v-for="(property, i) in propertiesList" :key="i")
        .col-sm-3: span.text-muted {{ property.name }}
        .col-sm-9 {{ property.valueFiltered }}
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true
    },
    properties: {
      type: Array,
      required: true
    }
  },
  filters: {
    none(val) {
      return val
    }
  },
  computed: {
    propertiesList() {
      return this.properties.map(prop => ({
        ...prop,
        valueFiltered: this.$options.filters[prop.filter || 'none'](prop.value)
      }))
    }
  }
}
</script>
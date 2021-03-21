<template lang="pug">
  slot(v-if="loaded")
</template>

<script>
const onlyKnownProperties = (apiModel, initialModel) => {
  // only leave properties that are present in initial model
  const entries = Object.keys(initialModel)
    .map(property => [property, apiModel.hasOwnProperty(property) ? apiModel[property] : initialModel[property]])
  const newValues = Object.fromEntries(entries)
  return { ...initialModel, ...newValues }
}

export default {
  props: {
    url: String,
    default: {
      type: Function,
      required: true
    },
    etag: {
      type: Number,
      default: Math.random()
    },
    callback: {
      type: Function,
      default: result => result
    }
  },
  data() {
    return {
      loaded: false
    }
  },
  methods: {
    reload() {
      if (this.url) {
        fetch(this.url, {
          method: 'GET',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        }).then(response => response.json())
          .then(result => {
            this.$emit('loaded', onlyKnownProperties(this.callback(result), this.default()))
            this.loaded = true
          })
      } else {
        this.$emit('loaded', this.default())
        this.loaded = true
      }
    }
  },
  watch: {
    etag: {
      handler: function() {
        this.reload()
      },
      immediate: true
    }
  }
}
</script>
<template lang="pug">
  slot(v-if="loaded")
</template>

<script>
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
            this.$emit('loaded', result)
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
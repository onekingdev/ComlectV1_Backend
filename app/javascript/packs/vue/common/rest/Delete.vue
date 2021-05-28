<template lang="pug">
  span(@click.stop.prevent="submit")
    slot
</template>

<script>
export default {
  props: {
    url: {
      type: String,
      required: true
    },
    headers: {
      type: Object,
      default: () => ({})
    }
  },
  methods: {
    submit() {
      fetch(this.url, {
        method: 'DELETE',
        headers: {'Accept': 'application/json', ...this.headers},
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => {
            Object.keys(errors)
              .map(prop => errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
            this.$emit('errors', errors)
          }).catch(() => this.toast('Error', 'Couldn\'t delete entry: Unknown error'))
        } else if (response.status === 201 || response.status === 200) {
          this.$emit('deleted')
        } else {
          this.toast('Error', 'Couldn\'t delete entry')
        }
      })
    }
  }
}
</script>
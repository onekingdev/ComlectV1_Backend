<template lang="pug">
  span(@click.stop.prevent="submit")
    slot
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
    },
    method: {
      type: String,
      default: 'POST'
    }
  },
  methods: {
    submit() {
      this.$emit('errors', [])

      const formData = new FormData()
      Object.keys(this.model).map(property => formData.append(property, this.model[property]))

      fetch(this.action, {
        method: 'POST',
        headers: {'Content-Type': 'multipart/form-data'},
        body: formData
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => {
            Object.keys(errors)
              .map(prop => errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`, true)))
            this.$emit('errors', errors)
          }).catch(() => this.toast('Error', 'Couldn\'t submit form: Unknown error', true))
        } else if (response.status >= 200 && response.status <= 299) {
          this.$emit('saved', response)
        } else {
          this.toast('Error', 'Couldn\'t submit form', true)
        }
      })
    }
  }
}
</script>
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
      fetch(this.action, {
        method: this.method,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json', ...this.headers},
        body: JSON.stringify(this.model)
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => {
            Object.keys(errors)
              .map(prop => errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            this.$emit('errors', errors)
          }).catch(() => this.makeToast('Error', 'Couldn\'t submit form: Unknown error'))
        } else if (response.status === 201 || response.status === 200) {
          this.$emit('saved')
          this.makeToast('Success', 'Saved')
        } else {
          this.makeToast('Error', 'Couldn\'t submit form')
        }
      })
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>
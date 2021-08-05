export default {
  methods: {
    toast(title, message, isError) {
      this.$bvToast.toast(message, {
        title,
        variant: isError ? 'danger' : 'success',
        autoHideDelay: 5000
      })
    }
  }
}

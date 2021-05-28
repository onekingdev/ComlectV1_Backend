<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Reset status")
      .d-block
        p
          b-icon.mr-3(icon="exclamation-triangle-fill" scale="2" variant="warning")
          | We've sent an email to the address used to log in to your Complect account. Please follow the instructions in the email to reset your password.
          br
          | Didn't receive an email?
          br
          | Check your spam folder or try again.
      p
        b Do you want to continue?
      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Send Email Again
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('resetPasswordAgainConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Publish Policy")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-2.ml-3(icon="exclamation-circle-fill" width="25" height="25" variant="info")
        .col
          p.m-b-10 The policy will be added to your compilance manual and employees will be able to view the new policy.
          p.mb-0
            b Do you want to continue?
      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Confirm
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
      submit(e) {
        e.preventDefault();
        this.errors = [];
        this.$emit('publishConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId"  title="Unsaved Changes")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(icon="exclamation-triangle-fill" variant="warning" width="25" height="25")
        .col
          div
            p.m-b-10 Exiting will remove any unsaved changes.
            p.mb-0: strong Do you want to continue?

      template(#modal-footer="{ hide }")
        button.btn.btn-link(@click="hide") Cancel
        button.btn.btn-dark(@click="exit") Confirm
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
    }
  },
  methods: {
    exit() {
      this.$bvModal.hide(this.modalId)
      this.back()
    }
  }
}
</script>

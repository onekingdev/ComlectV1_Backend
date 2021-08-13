<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Delete Category")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(icon="exclamation-circle-fill" width="25" height="25" variant="danger")
        .col
          p.m-b-10 This will remove the category from this internal review and all of its associated content.
          p.mb-0
            b Do you want to continue?

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-danger(@click="submit") Confirm
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

        this.$emit('deleteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

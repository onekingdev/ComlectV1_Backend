<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Delete Exam")
      .row
        .col-md-1.text-center.px-0
          img.mt-1.ml-3(src='@/assets/error_20.svg' width="25" height="25")
        .col
          p.m-b-10 Removing this exam will delete any progress and tasks associated with the file.
          p.mb-0
            b Do you want to continue?

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.btn-link.mr-2(@click="$bvModal.hide(modalId)") Cancel
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

        this.$emit('deleteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

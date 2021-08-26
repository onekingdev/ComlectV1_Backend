<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="completedStatus ? 'Incomplie Section' : 'Complete Section'")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(v-if="!completedStatus" icon="check-circle-fill" width="25" height="25" variant="success")
          b-icon.mt-1.ml-3(v-if="completedStatus" icon="exclamation-circle-fill" width="25" height="25" variant="danger")
        .col
          p.paragraph.m-b-10 This will mark the category as complete and your progress will be updated.
          p.paragraph.mb-0
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
      completedStatus: {
        type: Boolean,
        default: true
      },
      name: {
        type: String,
        default: 'General'
      }
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

        this.$emit('compliteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

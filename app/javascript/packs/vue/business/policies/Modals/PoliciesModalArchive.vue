<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="archiveStatus ? 'Archive Policy' : 'Unarchive Policy'")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(icon="exclamation-triangle-fill" width="25" height="25" variant="warning")
        .col
          p.paragraph.m-b-10 Archiving the policy will remove it from the published compliance manual, but maintain a record of the policy and all of its linked risks and tasks.
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
      archiveStatus: {
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
        this.$emit('archiveConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },

  }
</script>

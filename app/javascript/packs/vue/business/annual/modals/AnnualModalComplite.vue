<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Complie Section")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-2.ml-3(icon="check-circle-fill" scale="2" variant="success")
        .col
          p Confirm will make "General" section as complite.
            br
            b Do you want to continue?

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('compliteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

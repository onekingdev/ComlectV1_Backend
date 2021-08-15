<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Publish Policy")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(icon="check-circle-fill" width="25" height="25" variant="success")
        .col
          p.m-b-10 You are publishing a policy which will make it viewable to all users. It also be included in an official version of the compliance manual.
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

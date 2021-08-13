<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Role Types" hide-footer)
      .row
        .col-md-1.text-center.px-0
          // b-icon.mt-2.ml-3(icon="exclamation-circle-fill" scale="2" variant="danger")
          ion-icon.role-info__icon.black.mt-2.ml-3(name="people-outline" size="small")
        .col
          p.mb-0: b Admin
          p Full visibility and understricted access to features, functionalities, settings, and billing details.
      .row
        .col-md-1.text-center.px-0
          b-icon.role-info__icon.mt-2.ml-3(icon="check-square-fill" scale="1" variant="success")
        .col
          p.mb-0: b Trusted
          p Can view, create, and edit. Administrative access without financial settings.
      .row
        .col-md-1.text-center.px-0
          // b-icon.mt-2.ml-3(icon="exclamation-circle-fill" scale="2" variant="danger")
          ion-icon.role-info__icon.grey.mt-2.ml-3(name="person-circle-outline" size="small")
        .col
          p.mb-0: b Basic
          p Employee level access with limited settings.

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
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
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        // this.$emit('informConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

<style>
  ion-icon.black {
    color: #303132;
  }
  ion-icon.grey {
    color: #c6c8ce;
  }
</style>

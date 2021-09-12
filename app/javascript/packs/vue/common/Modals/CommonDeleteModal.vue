<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="title")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(icon="dash-circle-fill" width="25" height="25" variant="danger")
        .col
          p.paragraph.m-b-10 {{ content }}
          p.paragraph.mb-0
            b Do you want to continue?

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
      title: {
        type: String,
        default: '',
        required: true
      },
      content: {
        type: String,
        default: '',
        required: true
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`
      }
    },
    methods: {
      submit(e) {
        e.preventDefault()
        this.$emit('deleteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>
<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Remove Subsections")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-2.ml-3(icon="exclamation-circle-fill" scale="2" variant="danger")
        .col
          p.paragraph.m-b-10 Removing this subsections will permamently delete any items populated withing it.
          p.paragraph.mb-0
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
      flex: {
        type: Boolean,
        default: false
      },
      inline: {
        type: Boolean,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        policy: {
          name: '',
          description: 'N/A',
          sections: [],
        },
        errors: []
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('removeSubsectionConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
    computed: {

    },
    watch: {

    },
    components: {

    }
  }
</script>

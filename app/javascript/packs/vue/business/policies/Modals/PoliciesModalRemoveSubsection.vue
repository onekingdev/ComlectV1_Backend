<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Remove Subsection")
      .d-block
        p
          b-icon.mr-3(icon="exclamation-circle-fill" scale="2" variant="danger")
          | Removing this subsection will permamently delete any items populated withing it.
      p
        b Do you want to continue?
      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
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

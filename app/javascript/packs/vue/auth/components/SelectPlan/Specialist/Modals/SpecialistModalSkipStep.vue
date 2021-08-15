<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Skip This Step")
      .d-block
        p
          b-icon.mr-3(icon="exclamation-triangle-fill" scale="2" variant="warning")
          | This information will be important when sending out proposals to clients later.
        p Any changes made will be removed and you will proceed to the next step.
      p
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

        this.$emit('skipConfirmed')
        this.$bvModal.hide(this.modalId)

        // if (window.location.href === `${window.location.origin}/business/compliance_policies/${this.policyId}`) {
        //   window.location.href = `${window.location.origin}/business/compliance_policies/`
        // }
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

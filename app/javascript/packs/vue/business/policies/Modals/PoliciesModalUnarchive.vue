<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Unarchive Policy")
      .d-block
        p
          b-icon.mr-3(icon="exclamation-triangle-fill" scale="2" variant="warning")
          | Unarchiving the policy will place it back into the compilance manual.
      p
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
      policyId: {
        type: Number,
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

        // this.$emit('archiveConfirmed')
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

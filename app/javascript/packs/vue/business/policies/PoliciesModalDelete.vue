<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Delete policy")
      .d-flex
        b-icon.mr-3(icon="x-circle" scale="2" variant="danger")
        p Removing this policy will permanently delete any items populated within it.
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

        this.$emit('deleteConfirmed')
        this.$bvModal.hide(this.modalId)

        // fetch('/api/business/compliance_policies/' + this.policyId, {
        //   method: 'DELETE',
        //   headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        //   // body: JSON.stringify(this.policy)
        // }).then(response => {
        //   if (response.status === 422) {
        //     response.json().then(errors => {
        //       this.errors = errors
        //       Object.keys(this.errors)
        //         .map(prop => this.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
        //     })
        //   } else if (response.status === 201 || response.status === 200) {
        //     this.$emit('saved')
        //     this.makeToast('Success', 'The project has been removed')
        //     this.$bvModal.hide(this.modalId)
        //
        //
        //     // window.location.href = `${window.location.href}/create`;
        //     if (window.location.href === `${window.location.origin}/business/compliance_policies/${this.policyId}`) {
        //       window.location.href = `${window.location.origin}/business/compliance_policies/`
        //     }
        //   } else {
        //     this.makeToast('Error', 'Couldn\'t submit form')
        //   }
        // })
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

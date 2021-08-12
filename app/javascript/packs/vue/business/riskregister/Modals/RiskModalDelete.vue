<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Delete risk")
      .row
        .col-md-1.text-center.px-0
          //b-icon.mt-2.ml-3(icon="exclamation-circle-fill" scale="2" variant="danger")
          img(src='@/assets/error_20.svg' width="25" height="25")
        .col
          p You are about to delete the risk and romove any connections to its related controls.
            br
            b Do you want to continue?
      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.btn-link.mr-2(@click="$bvModal.hide(modalId)") Cancel
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
      riskId: {
        type: Number,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        risk: {
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

        this.$emit('deleteConfirmed')
        this.$bvModal.hide(this.modalId)

        if (window.location.href === `${window.location.origin}/business/risks/${this.riskId}`) {
          window.location.href = `${window.location.origin}/business/risks/`
        }

        // fetch('/api/business/risks/' + this.riskId, {
        //   method: 'DELETE',
        //   headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        //   // body: JSON.stringify(this.risk)
        // }).then(response => {
        //   if (response.status === 422) {
        //     response.json().then(errors => {
        //       this.errors = errors
        //       Object.keys(this.errors)
        //         .map(prop => this.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
        //     })
        //   } else if (response.status === 201 || response.status === 200) {
        //     this.$emit('saved')
        //     this.toast('Success', 'The project has been removed')
        //     this.$bvModal.hide(this.modalId)
        //
        //
        //     // window.location.href = `${window.location.href}/create`;

        //   } else {
        //     this.toast('Error', 'Couldn\'t submit form')
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

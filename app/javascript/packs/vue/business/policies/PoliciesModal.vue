<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New policy")
      label.form-label New policy
      input.form-control(v-model="policy.name" type="text" placeholder="Enter the name of your policy")
      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      }
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

        if (!this.policy.name) {
          this.errors.push('Name is required.');
          this.makeToast('Success', 'Name is required.')
          return;
        }
        console.log(this.policy);

        // this.$router.push('BusinessPoliciesCreatePage')
        // console.log(this.$router)

        window.location.href = `${window.location.href}/create`;
        return;

        fetch('/api/business/compliance_policies', {
          method: 'POST',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          body: JSON.stringify(this.policy)
        }).then(response => {
          console.log(response)
          if (response.status === 422) {
            response.json().then(errors => {
              this.errors = errors
              Object.keys(this.errors)
                .map(prop => this.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            })
          } else if (response.status === 201 || response.status === 200) {
            this.$emit('saved')
            this.makeToast('Success', 'The project has been saved')
            this.$bvModal.hide(this.modalId)
          } else {
            this.makeToast('Error', 'Couldn\'t submit form')
          }
        })
      },
    },
    computed: {

    },
    watch: {

    },
    components: {
      Errors: {
        template: `<div v-if="errors && errors[0]" v-text="errors[0]" class="d-block invalid-feedback" role="alert" aria-live="assertive" aria-atomic="true"/>`,
        props: {
          errors: Array
        }
      }
    }
  }
</script>

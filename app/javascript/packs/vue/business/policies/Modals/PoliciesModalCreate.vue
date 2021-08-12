<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New policy")
      label.form-label New policy name
      input.form-control(v-model="policy.name" ref="input" type="text" placeholder="Enter the name of your policy" @keyup.enter="submit" @input="clearErrors")
      Errors(:errors="errors")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
  import Errors from '@/common/Errors'
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      }
    },
    components: {
      Errors
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
      focusInput() {
        this.$refs.input.focus();
      },
      clearErrors() {
        this.errors = [];
      },
      submit(e) {
        e.preventDefault();

        this.errors = [];

        if (!this.policy.name) {
          this.errors.push(['Name is required']);
          this.toast('Error', 'Name is required.', true)
          return;
        }
        if (this.policy.name.length <= 3) {
          this.errors.push('Name is very short, must be more 3 characters.');
          this.toast('Error', 'Name is very short, must be more 3 characters.', true)
          return;
        }

        this.$store
          .dispatch('createPolicy', {
            name: this.policy.name
          })
          .then((response) => {
            if (response.errors) {
              this.toast('Error', `${response.status}`, true)
              this.errors.push({ title: `${response.errors.title}`});
              Object.keys(response.errors)
                .map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
            }
            if(!response.errors) {
              this.toast('Success', `Policy successfully created.`)
              this.$emit('savedConfirmed')
              this.$bvModal.hide(this.modalId)
              this.policy.name = ''
              //this.$router.push(`/business/compliance_policies/${response.id}`)
              this.$router.push({ name: 'policy-current', params: { policyId: response.id, toggleVueEditor: true }})
            }
          })
          .catch((error) => {
            console.error(error)
            this.toast('Error', error, true)
          });
      },
    },
  }
</script>

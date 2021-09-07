<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New policy")
      b-alert.m-b-20(v-if="error" variant="danger" show) {{ error }}

      label.form-label Policy Name
      input.form-control(v-model="policy.name" ref="input" type="text" @keyup.enter="submit" @input="clearErrors")
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
        errors: [],
        error: ''
      }
    },
    methods: {
      focusInput() {
        this.$refs.input.focus();
      },
      clearErrors() {
        this.error = ''
        this.errors = [];
      },
      submit(e) {
        e.preventDefault();
        this.clearErrors()

        if (!this.policy.name) {
          // this.errors.push('Name is required');
          this.error = 'Name is required'
          return;
        }
        if (this.policy.name.length <= 3) {
          // this.errors.push('Name is very short, must be more 3 characters.');
          this.error = 'Name must be more 3 characters'
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
              this.toast('Success', `Policy has been created.`)
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

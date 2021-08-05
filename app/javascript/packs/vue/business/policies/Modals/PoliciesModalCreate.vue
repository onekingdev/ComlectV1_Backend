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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      clearErrors() {
        this.errors = [];
      },
      submit(e) {
        e.preventDefault();

        this.errors = [];

        if (!this.policy.name) {
          this.errors.push(['Name is required']);
          this.makeToast('Error', 'Name is required.')
          return;
        }
        if (this.policy.name.length <= 3) {
          this.errors.push('Name is very short, must be more 3 characters.');
          this.makeToast('Error', 'Name is very short, must be more 3 characters.')
          return;
        }

        this.$store
          .dispatch('createPolicy', {
            name: this.policy.name
          })
          .then((response) => {
            if (response.errors) {
              this.makeToast('Error', `${response.status}`)
              this.errors.push({ title: `${response.errors.title}`});
              Object.keys(response.errors)
                .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            }
            if(!response.errors) {
              this.makeToast('Success', `Policy successfully created! You will be redirect...`)
              this.$emit('savedConfirmed')
              this.$bvModal.hide(this.modalId)
              this.policy.name = ''

              setTimeout(() => {
                // window.location.href = `${window.location.origin}/business/compliance_policies/${response.id}`
                this.$router.push(`/business/compliance_policies/${response.id}`)
              }, 1000)
            }
          })
          .catch((error) => {
            console.error(error)
            this.makeToast('Error', error)
          });
      },
    },
  }
</script>

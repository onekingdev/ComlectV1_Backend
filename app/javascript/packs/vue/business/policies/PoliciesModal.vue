<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New policy")
      label.form-label New policy name
      input.form-control(v-model="policy.name" type="text" placeholder="Enter the name of your policy" @keyup.enter="submit" ref="input")
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
      focusInput() {
        this.$refs.input.focus();
      },
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(e) {
        e.preventDefault();

        this.errors = [];

        if (!this.policy.name) {
          this.errors.push('Name is required.');
          this.makeToast('Error', 'Name is required.')
          return;
        }
        if (this.policy.name.length <= 3) {
          this.errors.push('Name is very short, must be more 3 characters.');
          this.makeToast('Error', 'Name is very short, must be more 3 characters.')
          return;
        }

        // this.$router.push('BusinessPoliciesCreatePage')
        // console.log(this.$router)

        fetch('/api/business/compliance_policies', {
          method: 'POST',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          body: JSON.stringify(this.policy)
        }).then(response => {
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

            // window.location.href = `${window.location.href}/create`;
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
    },
    mounted() {
      // this.focusInput()
    },
  }
</script>

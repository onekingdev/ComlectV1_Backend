<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="projectId ? 'Edit policy' : 'New policy'" @show="resetProject")
      label.form-label New policy
      input.form-control(v-model="policy.title" type="text" placeholder="Enter the name of your policy")
      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
  import { DateTime } from 'luxon'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const dateFormat = 'MM/DD/YYYY'
  const index = (text, i) => ({ text, value: 1 + i })

  const initialProject = () => ({
    title: "",
    starts_on: null,
    ends_on: null,
    description: ""
  })

  export default {
    props: {
      projectId: Number,
      remindAt: String,
      inline: {
        type: Boolean,
        default: true
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        policy: {
          id: +rnd(),
          ownerId: 1,
          title: 'Your policy name - rattattatttaaa' + rnd(),
          description: 'text DNA',
          sections: [],
        },
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(asDraft) {
        asDraft.preventDefault();

        this.errors = []

        if (!this.policy.title) {
          this.errors.push('Name required.');
        }
        console.log(this.policy);

        // this.$router.push('BusinessPoliciesCreatePage')
        // console.log(this.$router)

        window.location.href = `${window.location.href}/create`;
        return;

        const toId = this.policy.id ? `/${this.policy.id}` : '', draftParam = asDraft ? '?draft=1' : ''
        fetch('/api/business/compliance_policies' + toId + draftParam, {
          method: this.policy.id ? 'PUT' : 'POST',
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
            // this.resetProject()
          } else {
            this.makeToast('Error', 'Couldn\'t submit form')
          }
        })
      },
      resetProject() {
        if (this.projectId) {
          // fetch(`/api/business/local_projects/${this.projectId}`, {
          //     method: 'GET',
          //     headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
          // }).then(response => response.json())
          //     .then(result => Object.assign(this.project, result))
        } else {
          this.project = initialProject()
        }
      }
    },
    computed: {
      daysOfWeek() {
        return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map(index)
      },
      months() {
        return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map(index)
      },
      dateFormat: () => dateFormat
    },
    watch: {
      'project.starts_on': {
        handler: function(value, oldVal) {
          const start = DateTime.fromSQL(value), end = DateTime.fromSQL(this.project.ends_on)
          if (!start.invalid && (end.invalid || (end.startOf('day') < start.startOf('day')))) {
            this.project.ends_on = value
          }
        }
      }
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

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="user ? 'Edit User' : 'Add User'" @shown="getData")
      .row(v-if="!userLimit")
        .col-12.m-b-1
          Notifications(:notify="notify")
            button.btn.btn-default(@click='editPlan') Edit
      .row
        .col-sm-6.m-b-1
          label.form-label.required First Name
          input.form-control(v-model="form.first_name" type="text" placeholder="First Name" ref="input")
          Errors(:errors="errors.first_name")
        .col-sm-6.m-b-1
          label.form-label.required Last Name
          input.form-control(v-model="form.last_name" type="text" placeholder="Last Name" ref="input")
          Errors(:errors="errors.last_name")
      .row
        .col-12.m-b-1
          label.form-label.required Email
          input.form-control(v-model="form.email" type="text" placeholder="Enter email" ref="input")
          Errors(:errors="errors.email")
      .row
        .col-12.m-b-1
          label.form-label Role
            RoleTypesModalInfo
              b-icon.tooltip__icon(icon="exclamation-circle-fill" v-b-tooltip.hover title="Role Information")
          ComboBox(v-model="form.role" :options="roleOptions" placeholder="Select a role")
          Errors(:errors="errors.role")
      .row
        .col-12.m-b-1
          label.form-label Start Date
          DatePicker(v-model="form.start_date")
          Errors(:errors="errors.start_date")
      .row
        .col-12
          b-form-checkbox(v-model="form.access_person") Access Person
          Errors(:errors="errors.access")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") {{ user ? 'Save' : 'Add'  }}
</template>

<script>
  import RoleTypesModalInfo from "@/common/Users/modals/RoleTypesModalInfo";
  import Notifications from "@/common/Notifications/Notifications";

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: capitalize(id) })
  const capitalize = function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  }

  const initialForm = () => ({
    first_name: '',
    last_name: '',
    email: '',
    role: '',
    start_date: '',
    access_person: ''
  })

  export default {
    components: {Notifications, RoleTypesModalInfo},
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      user: {
        type: Object,
        required: false,
      },
      userLimit: {
        type: Number,
        required: false,
        default: null,
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        form: initialForm(),
        errors: {},
        notify: {
          show: 'show',
          mainText: 'User limit reached',
          subText: 'Please edit your plan in order to add additional users',
          variant: 'warning',
          dismissible: false,
          icon: null,
          scale: 2,
          animation: ""
        },
      }
    },
    methods: {
      getData() {
        if (this.user) this.form = this.user
      },
      submit(e) {
        e.preventDefault();

        try {

          const data = {
            team_member: {
              ...this.form,
              // first_name: 'Team',
              // last_name: 'Member',
              // email: 'team@member.com',
              // start_date: '2021-08-22',
              // access_person: '1',
              // role: 'basic'
            }
          }

          console.log('data', data)

          this.$store.dispatch('settings/createEmployee', data)
            .then((response) => {
              if (response.errors) {
                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                }
                if (response.errors.seat) this.toast('Error', `${response.errors.seat}`, true)
              }

              if (!response.errors) {
                this.toast('Success', `User successfully added/edited!`)
                this.$emit('saved')
                this.$bvModal.hide(this.modalId)
              }
            })
            .catch((error) => this.toast('Error', `Couldn't submit form! ${error}`, true))

        } catch (error) {
          this.toast('Error', error.message)
        }
      },
      editPlan() {
        this.$bvModal.hide(this.modalId)
        this.$emit('editPlan')
      },
    },
    computed: {
      roleOptions() {
        return ['', 'basic', 'trusted', 'admin'].map(toOption)
      }
    },
  }
</script>

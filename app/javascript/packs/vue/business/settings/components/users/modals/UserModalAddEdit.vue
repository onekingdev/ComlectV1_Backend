<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="user ? 'Edit User' : 'Add User'")
      .row
        .col-12.m-b-1
          Notifications(:notify="notify")
            button.btn.btn-default(@click='editUser') Edit
      .row
        .col-sm-6.m-b-1
          label.form-label First Name
          input.form-control(v-model="form.first_name" type="text" placeholder="First Name" ref="input")
          Errors(:errors="errors.first_name")
        .col-sm-6.m-b-1
          label.form-label Last Name
          input.form-control(v-model="form.last_name" type="text" placeholder="Last Name" ref="input")
          Errors(:errors="errors.last_name")
      .row
        .col-12.m-b-1
          label.form-label Email
          input.form-control(v-model="form.email" type="text" placeholder="Enter email" ref="input")
          Errors(:errors="errors.email")
      .row
        .col-12.m-b-1
          label.form-label Role
          ComboBox(v-model="form.role" :options="roleOptions" placeholder="Select a role")
          Errors(:errors="errors.role")
      .row
        .col-12.m-b-1
          label.form-label Start Date
          DatePicker(v-model="form.start_date" :options="datepickerOptions")
          Errors(:errors="errors.start_date")
      .row
        .col-12.p-x-2
          b-form-checkbox(v-model="form.access") Access Person
          Errors(:errors="errors.access")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") {{ user ? 'Edit' : 'Add'  }}
</template>

<script>
  import RoleTypesModalInfo from "./RoleTypesModalInfo";
  import Notifications from "@/common/Notifications/Notifications";
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: id })

  const initialForm = () => ({
    first_name: '',
    last_name: '',
    email: '',
    role: '',
    start_date: '',
    access: ''
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
        default: () => {}
      }
    },
    created() {
      if (this.user) this.form = Object.assign({}, this.user, this.form)
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
        }
      }
    },
    methods: {
      async submit(e) {
        e.preventDefault();

        try {

          this.toast('Success', `User successfully added/edited!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
        } catch (error) {
          this.toast('Error', error.message)
        }
      },
      editUser(value) {
        console.log(value)
        console.log('123')
      },
    },
    computed: {
      datepickerOptions() {
        return {
          min: new Date
        }
      },
      roleOptions() {
        return ['Basic', 'Trusted', 'Admin'].map(toOption)
      }
    },
  }
</script>

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Add User")
      .row
        .col-12.m-b-1
          label.form-label Email
          input.form-control(v-model="user.email" type="text" placeholder="Enter email" ref="input")
          Errors(:errors="errors.email")
      .row
        .col-12.m-b-1
          label.form-label Role
            RoleTypesModalInfo
              b-icon.ml-2.mb-1(icon="exclamation-circle-fill" variant="secondary" v-b-tooltip.hover title="Toooooooltip" font-scale="1")
          ComboBox(v-model="user.role" :options="roleOptions" placeholder="Select a role")
          Errors(:errors="errors.role")
      .row
        .col-12.m-b-1
          label.form-label Start Date
          DatePicker(v-model="user.start_date" :options="datepickerOptions")
          Errors(:errors="errors.start_date")
      .row
        .col-12.p-x-2
          b-form-checkbox(v-model="user.access") Access Person
          Errors(:errors="errors.access")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Add
</template>

<script>
  import RoleTypesModalInfo from "./RoleTypesModalInfo";
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: id })

  export default {
    components: {RoleTypesModalInfo},
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        user: {
          email: '',
          role: '',
          start_date: '',
          access: ''
        },
        errors: {},
      }
    },
    methods: {
      async submit(e) {
        e.preventDefault();

        try {

          this.toast('Success', `User successfully added!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
        } catch (error) {
          this.toast('Error', error.message)
        }
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

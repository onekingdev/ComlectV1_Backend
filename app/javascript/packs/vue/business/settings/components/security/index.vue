<template lang="pug">
  div
    .row
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Security
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4 Change Email
              .row
                .col-md-8.col-lg-6
                  b-form(@submit='onSubmitEmail' v-if='show1')
                    b-form-group#input-group-1(label='Email' label-for='input-1' label-class="settings__card--label required")
                      .d-flex
                        b-form-input#input-1(v-model='form1.email' type='email' placeholder='Email' :class="{'is-invalid': errors.email }")
                        b-button.ml-2(type='submit' variant="dark") Save
                      Errors(:errors="errors.email")
                  b-form(@submit='onSubmitResetPassword' @reset="onResetPassword" v-if='show2')
                    b-form-group.p-t-1
                      h4 Reset Password
                    b-form-group#input-group-2(label='Old Password' label-for='input-2'  label-class="settings__card--label required" )
                      b-form-input#input-2(v-model='form2.current_password' type='password' placeholder='Old Password' :class="{'is-invalid': errors.current_password }")
                      Errors(:errors="errors.current_password")
                    b-form-group#input-group-3(label='New Password' label-for='input-3' description="Minimum 6 character" label-class="settings__card--label required" )
                      b-form-input#input-3(v-model='form2.password' type='password' placeholder='New Password' :class="{'is-invalid': errors.password }")
                      Errors(:errors="errors.password")
                    b-form-group#input-group-4(label='Confirm Password' label-for='input-4' label-class="settings__card--label required")
                      b-form-input#input-4(v-model='form2.password_confirmation' type='password' placeholder='Confirm Password' :class="{'is-invalid': errors.password_confirmation }")
                      Errors(:errors="errors.password_confirmation")
                    b-form-group.d-flex.justify-content-end.m-t-20
                      b-button.btn.btn-link.mr-2(type='reset') Cancel
                      b-button.btn(type='submit' variant='dark') Save
            hr
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4 Delete Account
              .row
                .col-md-6
                  p By deleting your account, you will purge all account information&nbsp;
                    | and saved documents associated with this account. This deletion cannot be reversed.&nbsp;
                    | Please take appropriate steps to save down to your own storage devices&nbsp;
                    | those records you may wish to access after the deletion of this account.
                  DeleteAccountModal(@deleteConfirmed="deleteAccount")
                    button.btn.btn-warning.font-weight-bold Delete
</template>

<script>
  import { mapActions } from 'vuex'
  import Loading from '@/common/Loading/Loading'
  import DeleteAccountModal from './modals/AccountModalDelete'

  const initialFormEmail = () => ({
    email: '',
  })

  const initialFormResetPassword = () => ({
    current_password: '',
    password: '',
    password_confirmation: '',
  })

  export default {
    components: {
      Loading,
      DeleteAccountModal
    },
    data() {
      return {
        show1: true,
        show2: true,
        form1: initialFormEmail(),
        form2: initialFormResetPassword(),
        errors: {},
      };
    },
    methods: {
      ...mapActions({
        resetEmail: 'settings/resetEmailSettings',
        updatePassword: 'settings/updatePasswordSettings',
        deleteAccount: 'settings/deleteAccount',
      }),
      async onSubmitEmail(event) {
        event.preventDefault()
        for (let value in this.errors) delete this.errors[value];

        // const data = {
        //   "email": this.form1.email,
        // }
        const data = {
          "user": {
            email: this.form1.email,
          },
        }

        try {
          const response = await this.resetEmail(data)
          if (response) {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                this.errors = Object.assign(this.errors, { [key]: value })
                this.toast('Error', `${key} ${value}`, true)
              }
              if (response.errors.not_found) this.errors = Object.assign(this.errors, { email: [response.errors.not_found] })
            }
            if (!response.errors) {
              this.toast('Success', `${response.message}`)
            }
            if (!response) console.error(response)

            this.show1 = false
            this.$nextTick(() => {
              this.show1 = true
            })

          }
        } catch (erroe) {
          console.error(error)
        }
      },
      async onSubmitResetPassword(event) {
        event.preventDefault()
        for (let value in this.errors) delete this.errors[value];

        const data = {
          "user": {
            ...this.form2
          },
        }

        try {
          const response = await this.updatePassword(data)
          if (response) {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                this.errors = Object.assign(this.errors, { [key]: value })
                this.toast('Error', `${key} ${value}`, true)
              }
            }
            if (!response.errors) {
              this.toast('Success', `${response.message}`)
            }
          }
          if (!response) console.error(response)

          this.show2 = false
          this.$nextTick(() => {
            this.show2 = true
          })

        } catch (error) {
          console.error(error)
        }
      },
      onResetPassword(event) {
        event.preventDefault()
        // Reset our form values
        this.form2 = initialFormResetPassword()
        // Trick to reset/clear native browser form validation state
        this.show2 = false
        this.$nextTick(() => {
          this.show2 = true
        })
      },
      async deleteAccount () {
        try {
          const response = await this.deleteAccount
          if (response) {
            if (response.errors) {
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                this.toast('Error', `${response.errors[type]}`, true)
              }
            }
            if (!response.errors) {
              this.toast('Success', `${response.message}`)
            }
          }
          if (!response) console.error(response)
        } catch (error) {
          console.error(error)
        }
      }
    },
  };
</script>

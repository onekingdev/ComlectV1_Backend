<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Security
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4
                    b Change Email
              .row
                .col-md-8.col-lg-6
                  b-form(@submit='onSubmit' @reset="onReset" v-if='show')
                    b-form-group#input-group-1(label='Email' label-for='input-1' label-class="settings__card--label")
                      b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required :class="{'is-invalid': errors.email }")
                      .invalid-feedback.d-block(v-if="errors.email") {{ errors.email[0] }}
                    b-form-group.p-t-1
                      h4
                        b Reset Password
                    b-form-group#input-group-2(label='Old Password' label-for='input-2'  label-class="settings__card--label" )
                      b-form-input#input-2(v-model='form.current_password' type='password' placeholder='Old Password' required :class="{'is-invalid': errors.current_password }")
                      .invalid-feedback.d-block(v-if="errors.current_password") {{ errors.current_password[0] }}
                    b-form-group#input-group-3(label='New Password' label-for='input-3' description="Minimum 6 character" label-class="settings__card--label" )
                      b-form-input#input-3(v-model='form.password' type='password' placeholder='New Password' required :class="{'is-invalid': errors.password }")
                      .invalid-feedback.d-block(v-if="errors.password") {{ errors.password[0] }}
                    b-form-group#input-group-4(label='Confirm Password' label-for='input-4' label-class="settings__card--label")
                      b-form-input#input-4(v-model='form.password_confirmation' type='password' placeholder='Confirm Password' required :class="{'is-invalid': errors.password_confirmation }")
                      .invalid-feedback.d-block(v-if="errors.password_confirmation") {{ errors.password_confirmation[0] }}
                    b-form-group.text-right
                      b-button.btn.link.mr-2(type='reset' variant='none') Cancel
                      b-button.btn(type='submit' variant='dark') Save
            hr
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4
                    b Delete Account
              .row
                .col-md-6
                  p By deleting your account, you will purge all account information&nbsp;
                    | and saved documents associated with this account. This deletion cannot be reserved.&nbsp;
                    | Please take appropriate steps to save down to your own storage devices&nbsp;
                    | thise records you may wish to access after the deletion of this account
                  DeleteAccountModal(@deleteConfirmed="deleteAccount('1')")
                    button.btn.btn-warning.font-weight-bold Delete
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import DeleteAccountModal from './modals/AccountModalDelete'

  const initialForm = () => ({
    email: '',
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
        show: true,
        form: initialForm(),
        timeZoneOptions: [],
        options: {
          timeZone: [],
          country: [],
          state: [],
          city: [],
        },
        errors: {},
      };
    },
    methods: {
      onSubmit (event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        const data = {
          "user": {
            current_password: this.form.current_password,
            password: this.form.password,
            password_confirmation: this.form.password_confirmation,
          },
        }

        this.$store.dispatch('settings/updatePasswordSettings', data)
          .then((response) => {
            console.log(response)
            if (response.errors) {
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                this.toast('Error', `Form has errors! Please recheck fields! ${response.errors[type]}`)
              }
            }
            if (!response.errors) {
              this.toast('Success', `${response.message}`)
            }
          })
          .catch((error) => {
            console.error(error)
            const { data } = error
            if(data.errors) {
              for (const type of Object.keys(data.errors)) {
                this.toast('Error', `${data.errors[type]}`)
                this.error = `Error! ${data.errors[type]}`
              }
            }
            if (error.errors) {
              this.toast('Error', `Couldn't submit form! ${error.message}`)
            }
            if (!error.errors) {
              this.toast('Error', `${error.status} (${error.statusText})`)
            }
          })
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form = initialForm()
        this.form.checked = []
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      },
      deleteAccount (id) {
        console.log(id)
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    mounted() {

    },
  };
</script>

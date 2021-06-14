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
                      b-form-input#input-2(v-model='form.old_password' type='password' placeholder='Old Password' required :class="{'is-invalid': errors.old_password }")
                      .invalid-feedback.d-block(v-if="errors.old_password") {{ errors.old_password[0] }}
                    b-form-group#input-group-3(label='New Password' label-for='input-3' description="Minimum 6 character" label-class="settings__card--label" )
                      b-form-input#input-3(v-model='form.new_password' type='password' placeholder='New Password' required :class="{'is-invalid': errors.new_password }")
                      .invalid-feedback.d-block(v-if="errors.new_password") {{ errors.new_password[0] }}
                    b-form-group#input-group-4(label='Confirm Password' label-for='input-4' label-class="settings__card--label")
                      b-form-input#input-4(v-model='form.confirm_password' type='password' placeholder='Confirm Password' required :class="{'is-invalid': errors.confirm_password }")
                      .invalid-feedback.d-block(v-if="errors.confirm_password") {{ errors.confirm_password[0] }}
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
    old_password: '',
    new_password: '',
    confirm_password: '',
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
            "email": this.form.email,
            "password": this.form.password
          },
        }

        this.$store.dispatch('singIn', data)
          .then((response) => console.log(error))
          .catch((error) => console.error(error))
      },

      onChange (value) {
        if(value) {

        }
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

<style>
  .invalid-feedback {
    color: #CE1938;
  }
</style>

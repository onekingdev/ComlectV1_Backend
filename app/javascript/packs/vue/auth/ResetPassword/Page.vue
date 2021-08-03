<template lang="pug">
  .card.registration
    .card-body.white-card-body
      //Loading
      // #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
      .form
        .registration-welcome
          h1.registration__title Reset Password
          p.registration__subtitle.registration__subtitle_forgot Please enter the email address used to log into your account to receive a link to reset your password. If you no longer have access to that email account, please contact us at help@complect.com for assistance.
        div
          .invalid-feedback.d-block.text-center.m-b-20(v-if="error") {{ error }}
          b-form(@submit='onSubmit1' v-if='show')
            b-form-group#input-group-1.m-b-20(label='Email Address:' label-for='input-1')
              b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required)
              .invalid-feedback.d-block(v-if="errors['user.email']") 'Email Address' {{ ...errors['user.email'] }}
            b-button.registration__btn.w-100(type='submit' variant='dark') Reset
    .card-footer
      b-form-group.text-center.mb-0
        router-link.btn.link(to='/users/sign_in') Cancel
</template>

<script>
  // import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../components/TopNavbar";
  import ResetPasswordModal from './Modals/ResetPasswordModal'

  export default {
    components: {
      // Loading,
      TopNavbar,
      ResetPasswordModal,
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: '',
        form: {
          email: '',
        },
        show: true,
        error: '',
        errors: {},
      }
    },
    methods: {
      selectType(type){
        this.userType = type
      },
      onSubmit1(event) {
        event.preventDefault()
        // clear errors
        this.error = ''
        this.errors = []

        const data = {
          "email": this.form.email,
        }

        this.$store.dispatch('resetEmail', data)
          .then((response) => {
            if (response.errors) {
              const properties = Object.keys(response.errors);
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                // this.toast('Error', `Form has errors! Please recheck fields! ${error}`)
                // Object.keys(response.errors[type]).map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
              }
            }
            if (!response.errors) {
              // this.userId = response.userid
              // this.toast('Success', `${response.message}`)

              // open step 2
              // this.step1 = false
              // this.step2 = true

              window.location.href = `${window.location.origin}/users/sign_in`
            }

            // setTimeout(() => {
            //   window.location.href = `/users/sign_in`;
            // }, 3000)
          })
          .catch((error) => {
            console.error(error)
            this.error = `${error.status} ${error.statusText}`
          })
      },
    },
    computed: {
      // loading() {
      //   return this.$store.getters.loading;
      // },
    },
  }
</script>

<style module>
  @import "../styles.css";
</style>

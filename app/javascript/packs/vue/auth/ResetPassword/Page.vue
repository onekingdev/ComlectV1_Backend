<template lang="pug">
  div
    .container-fluid
      TopNavbar
      main.row#main-content
        .col-xl-4.col-lg-6.col-md-8.m-x-auto
          .card.registration
            .card-body.white-card-body
              Loading
              // #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              #step1.form(:class="step1 ? 'd-block' : 'd-none'")
                .registration-welcome.text-center
                  h1.registration__title Reset password
                  p.registration__subtitle Enter the email address used to log in to your Complect
                    | account and we'll send you a link to reset your password. If you
                    | are a business, we'll send the email to your key contact.
                div
                  b-alert(:show='dismissCountDown' dismissible fade variant='danger' @dismiss-count-down='countDownChanged')
                    | {{ error }}
                    br
                    | This alert will dismiss after {{ dismissCountDown }} seconds...
                  b-form(@submit='onSubmit1' v-if='show')
                    b-form-group#input-group-1.m-b-20(label='Email Address:' label-for='input-1')
                      b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required)
                      .invalid-feedback.d-block(v-if="errors['user.email']") 'Email Address' {{ ...errors['user.email'] }}
                    b-button.registration__btn.w-100(type='submit' variant='dark') Reset
              #step2.form(:class="step2 ? 'd-block' : 'd-none'")
                h1.text-center You successfuly reseted password!
                p.text-center You will be redirect to the sign in page!
                .text-center
                  b-icon(icon="circle-fill" animation="throb" font-scale="5")
                    //ion-icon(name="checkmark-circle-outline" size="large")-->
            .card-footer.text-center
              b-form-group
                a.link(data-remote='true' href='/users/sign_in') Cancel
                //router-link.link(to='/users/sign_in') Cancel
</template>

<script>
  // import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../components/TopNavbar";
  import ResetPasswordModal from './Modals/ResetPasswordModal'

  const TIME_FOR_VIEW_MESSAGE = 3000

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
        step1: true,
        step2: false,
        dismissSecs: 8,
        dismissCountDown: 0,
        showDismissibleAlert: false,
      }
    },
    methods: {
      selectType(type){
        this.userType = type
      },
      onSubmit1(event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        let dataToSend;

        dataToSend = {
          "email": this.form.email,
        }

        this.$store.dispatch('resetEmail', dataToSend)
          .then((response) => {
            if (response.errors) {
              const properties = Object.keys(response.errors);
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                this.toast('Error', `Form has errors! Please recheck fields! ${error}`)
                // Object.keys(response.errors[type]).map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
              }
            }
            if (!response.errors) {
              // this.userId = response.userid
              // this.toast('Success', `${response.message}`)

              // open step 2
              this.step1 = false
              this.step2 = true

              setTimeout(() => {
                window.location.href = `${window.location.origin}/users/sign_in`
              }, TIME_FOR_VIEW_MESSAGE)
            }

            // setTimeout(() => {
            //   window.location.href = `/users/sign_in`;
            // }, 3000)
          })
          .catch((error) => {
            console.error(error)
            for (const type of Object.keys(error.errors)) {
              this.toast('Error', `${error.errors[type]}`)
              this.error = `Error! ${error.errors[type]}`
            }
            this.showAlert()
          })
      },
      countDownChanged(dismissCountDown) {
        this.dismissCountDown = dismissCountDown
      },
      showAlert() {
        this.dismissCountDown = this.dismissSecs
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

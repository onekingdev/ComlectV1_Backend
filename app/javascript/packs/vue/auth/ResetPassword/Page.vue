<template lang="pug">
  div
    .container-fluid
      TopNavbar
      main.row#main-content
        .col-xl-4.col-lg-6.col-md-8.m-x-auto
          .card-body.white-card-body.registration
            Loading
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h1.text-center Reset password via email
              p.text-center Enter the email address used to log in to your Complect
                br
                | account and we'll send you a link to reset your password. If you
                br
                | are a business, we'll send the email to your key contact.
              div
                b-alert(:show='dismissCountDown' dismissible fade variant='danger' @dismiss-count-down='countDownChanged')
                  | {{ error }}
                  br
                  | This alert will dismiss after {{ dismissCountDown }} seconds...
                b-form(@submit='onSubmit1' v-if='show')
                  b-form-group#input-group-1(label='Email Address:' label-for='input-1')
                    b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required)
                    .invalid-feedback.d-block(v-if="errors['user.email']") 'Email Address' {{ ...errors['user.email'] }}
                  b-button.w-100(type='submit' variant='dark') Reset
                  hr
                  b-form-group.text-center.forgot-password.m-t-1
                    .m-t-1
                      .forgot-password.m-t-1.m-b-2
                        a.link(data-remote='true' href='/users/sign_in') Cancel
            #step2.form(v-if='!loading' :class="step2 ? 'd-block' : 'd-none'")
              h1.text-center You successfuly reseted password!
              p.text-center You will be redirect to the sign in page!
              .text-center
                b-icon( icon="circle-fill" animation="throb" font-scale="4")
                  <!--ion-icon(name="checkmark-circle-outline" size="large")-->
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../components/TopNavbar";
  import ResetPasswordModal from './Modals/ResetPasswordModal'

  const random = Math.floor(Math.random() * 1000);

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states'],
    components: {
      Loading,
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
              return
            }

            if (!response.errors) {
              this.userId = response.userid
              this.toast('Success', `${response.message}`)

              // open step 2
              this.step1 = false
              this.step2 = true
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
      loading() {
        return this.$store.getters.loading;
      },
    },
  }
</script>

<style scoped>
  @import "../styles.css";
</style>

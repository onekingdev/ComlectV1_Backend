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
                b-card.mt-3(header='Form Data Result')
                  pre.m-0 {{ form }}
            #step2.form(v-if='!loading' :class="step2 ? 'd-block' : 'd-none'")
              h1.text-center You successfuly reseted password!
              p.text-center You will be redirect to the sign in page!
              .text-center
                b-icon( icon="circle-fill" animation="throb" font-scale="4")
                  <!--ion-icon(name="checkmark-circle-outline" size="large")-->
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../SingIn/TopNavbar";
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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
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

        console.log('dataToSend', dataToSend)

        this.$store.dispatch('resetEmail', dataToSend)
          .then((response) => {
            console.log('response', response)

            if (response.errors) {
              const properties = Object.keys(response.errors);
              console.log('properties', properties)
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                this.makeToast('Error', `Form has errors! Please recheck fields! ${error}`)
                // Object.keys(response.errors[type]).map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
              }
              return
            }

            if (!response.errors) {
              this.userId = response.userid
              this.makeToast('Success', `${response.message}`)

              // open step 2
              this.step1 = false
              this.step2 = true
            }

            // setTimeout(() => {
            //   window.location.href = `/users/sign_in`;
            // }, 3000)
          })
          .catch((error) => {
            console.error('error', error)
            for (const type of Object.keys(error.errors)) {
              console.log('type', type)
              this.makeToast('Error', `${error.errors[type]}`)
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

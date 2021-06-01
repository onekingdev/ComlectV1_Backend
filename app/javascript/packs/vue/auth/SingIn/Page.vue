<template lang="pug">
  div
    .container-fluid(v-if='!childDataLoaded')
      TopNavbar
      main.row#main-content
        .col-xl-4.col-lg-6.col-md-8.m-x-auto
          .card-body.white-card-body.registration
            Loading

            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h1.text-center Let's get you started!
              p.text-center Enter to the system
              div
                b-alert(:show='dismissCountDown' dismissible fade variant='danger' @dismiss-count-down='countDownChanged')
                  | {{ error }}
                  br
                  | This alert will dismiss after {{ dismissCountDown }} seconds...
                b-form(@submit='onSubmit1' v-if='show')
                  b-form-group#input-group-1(label='Email:' label-for='input-1')
                    b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required)
                    .invalid-feedback.d-block(v-if="errors['user.email']") 'Email' {{ ...errors['user.email'] }}
                  b-form-group#input-group-2(label='Password:' label-for='input-2')
                    b-form-input#input-2(v-model='form.password' type='password' placeholder='Password' required)
                    .invalid-feedback.d-block(v-if="errors['user.password']") 'Email' {{ ...errors['user.password'] }}
                  b-button.w-100(type='submit' variant='dark') Sign In
                  hr
                  b-form-group.text-center.forgot-password.m-t-1
                    // p Forget your password?&nbsp;
                    //  a.link(href="#") Restore
                    a.link.o-8.forgot-password(data-remote='true' href='/users/password/new') Forgot Password
                    h4.text-uppercase.m-t-1.m-b-1 Don’t have an account yet?&nbsp;
                      a.link(data-remote='true' href='/users/sign_up') sign up here
            #step2.form(v-if='!loading' :class="step2 ? 'd-block' : 'd-none'")
              h1.text-center Confirm your email!
              p.text-center We send a 6 digit code to email.com. Please enter it below.
              div
                b-form(@submit='onSubmitStep2' @keyup="onCodeChange" v-if='show' autocomplete="off")
                  b-form-group
                    .col.text-center
                      ion-icon(name="mail-outline")
                  b-form-group
                    .row
                      .col-12.mx-0
                        .d-flex.justify-content-space-around.mx-auto.w-75
                          b-form-input#inputCode1.code-input.ml-auto(v-model='form2.codePart1' type='number' maxlength="1" required)
                          b-form-input#inputCode2.code-input(v-model='form2.codePart2' type='number' maxlength="1" required)
                          b-form-input#inputCode3.code-input(v-model='form2.codePart3' type='number' maxlength="1" required)
                          b-form-input#inputCode4.code-input(v-model='form2.codePart4' type='number' maxlength="1" required)
                          b-form-input#inputCode5.code-input(v-model='form2.codePart5' type='number' maxlength="1" required)
                          b-form-input#inputCode6.code-input.mr-auto(v-model='form2.codePart6' type='number' maxlength="1" required)
                        .invalid-feedback.d-block.text-center(v-if="errors.code") {{ errors.code }}
                    .row
                      .col
                        input(v-model='form2.code' type='hidden')
                  b-button.w-100(type='submit' variant='dark' ref="codesubmit") Submit
                  a.link(href="#" @click.stop="resendOTP") Send new code
            #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
              h1.text-center You successfuly logged in!
              p.text-center.m-b-2 You will be redirect to the dashboard!
                b-icon.ml-2(icon="circle-fill" animation="throb" font-scale="1")
              .text-center
                ion-icon(name="checkmark-circle-outline")
              p.text-center If you don't want to wait. Please&nbsp;
                a.link(:href="dashboardLink") click here
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "./TopNavbar";

  const random = Math.floor(Math.random() * 1000);

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states'],
    components: {
      TopNavbar,
      Loading,
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: '',
        form: {
          email: '',
          password: '',
        },
        form2: {
          codePart1: '',
          codePart2: '',
          codePart3: '',
          codePart4: '',
          codePart5: '',
          codePart6: '',
          code: '',
        },
        show: true,
        error: '',
        errors: {},
        step1: true,
        step2: false,
        step3: false,
        childDataLoaded: false,
        childdata : [],
        component: '',
        dismissSecs: 8,
        dismissCountDown: 0,
        showDismissibleAlert: false,
        dashboardLink: ''
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
          "user": {
            "email": this.form.email,
            "password": this.form.password
          },
        }

        this.$store.dispatch('singIn', dataToSend)
          .then((response) => {

            if (response.errors) {
              const properties = Object.keys(response.errors);
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
          })
          .catch((error) => {
            console.error(error)
            for (const type of Object.keys(error.errors)) {
              this.makeToast('Error', `${error.errors[type]}`)
              this.error = `Error! ${error.errors[type]}`
            }
            this.showAlert()
          })
      },
      onSubmitStep2(event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        if(this.form2.code.length !== 6) {
          this.makeToast('Error', `Code length incorrect!`)
          return
        }

        const dataToSend = {
          "user": {
            "email": this.form.email,
            "password": this.form.password
          },
          "otp_secret": this.form2.code
        }

        this.$store.dispatch('singIn', dataToSend)
          .then((response) => {

            if (response.errors) {
              const properties = Object.keys(response.errors);
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                this.makeToast('Error', `Form has errors! Please recheck fields! ${error}`)
                // Object.keys(response.errors[type]).map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
              }
              return
            }

            if (!response.errors && response.token) {
              // open step 3
              this.step2 = false
              this.step3 = true

              this.makeToast('Success', `You will be redirect to the dashboard!`)

              const dashboard = response.business ? '/business' : '/specialist'
              this.dashboardLink = dashboard
              setTimeout(() => {
                window.location.href = `${dashboard}`;
              }, 3000)
            }
          })
          .catch((error) => this.makeToast('Error', `Couldn't submit form! ${error}`))
      },
      onCodeChange(e){
        this.errors = []

        if (e.keyCode === 8 || e.keyCode === 46) {
          // BACKSPACE === 8 DELETE === 46
          e.preventDefault();
          e.target.value = ''
          e.target.previousElementSibling?.focus()
          return
        }

        if (e.target.value.length < 6) {
          e.preventDefault();
          e.target.value = e.key
          if(e.target.nextElementSibling) {
            e.target.nextElementSibling.value = ''
            e.target.nextElementSibling.focus()
          }

          if(!e.target.nextElementSibling) {
            this.$refs.codesubmit.focus();
          }
        }

        // CATCH COPY PASTE CASE
        if (e.target.value.length === 6) {
          for(let i=1; i <= 6; i++) {
            this.form2['codePart'+i] = e.target.value.charAt(i-1)
          }
        }

        this.form2.code = this.form2.codePart1 + this.form2.codePart2 + this.form2.codePart3 + this.form2.codePart4 + this.form2.codePart5 + this.form2.codePart6

        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.onSubmitStep2(e)
        }
      },
      resendOTP() {
        let dataToSend = {
          "user": {
            "email": this.form.email,
          },
        }

        this.$store.dispatch('resendOTP', dataToSend)
          .then((response) => console.log(response))
          .catch((error) => console.error(error))
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
      logIn() {
        return this.$store.getters.logIn;
      },
    },
  }
</script>

<style scoped>
  @import "../styles.css";
</style>

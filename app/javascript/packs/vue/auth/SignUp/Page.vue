<template lang="pug">
  div
    template(v-if='childDataLoaded')
      component(v-bind:is="component" :userInfo='childdata', :industryIds="industryIds", :jurisdictionIds="jurisdictionIds", :subIndustryIds="subIndustryIds", :states="states", :timezones="timezones")
    .container-fluid(v-if='!childDataLoaded')
      TopNavbar
      main.row#main-content
        .col-xl-5.col-lg-6.col-md-8.m-x-auto
          .card-body.white-card-body.registration
            Loading
            #step0.form(v-if='!loading' :class="step0 ? 'd-block' : 'd-none'")
              h1.text-center Let's get you started!
              p.text-center Select your account type
              div
                b-form(@submit='onSubmit0' v-if='show')
                  b-form-group
                    .row
                      .col-sm-6.col-12.pr-md-2.text-center.mb-sm-0.mb-3
                        .account-select(@click="selectType('business')" :class="userType === 'business' ? 'active' : ''")
                          h3.account-select__title.mb-3 I am a business
                          img.mb-3(src='@/assets/business-outline.svg' width="50")
                          p.account-select__subtitle Looking to effectively manage my compliance program and find expertise
                      .col-sm-6.col-12.pl-md-2.text-center
                        .account-select(@click="selectType('specialist')" :class="userType === 'specialist' ? 'active' : ''")
                          h3.account-select__title.mb-3 I am a specialist
                          img.mb-3(src='@/assets/briefcase-outline.svg' width="50")
                          p.account-select__subtitle Looking to work with potential clients on compliance projects
                  b-button.w-100(type='submit' variant='dark') Next
                  hr
                  b-form-group.text-center.mb-0
                    p.mb-0 Already have a Complect account?&nbsp;
                      a.link(href="/users/sign_in") Sign In
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h1.text-center Let's get you started!
              p.text-center Create your FREE account
              div
                b-form(@submit='onSubmit1' v-if='show')
                  .row
                    .col.pr-2
                      b-form-group#input-group-1(label='First Name:' label-for='input-1')
                        b-form-input#input-1(v-model='form.firstName' type='text' placeholder='First Name' min="3" required)
                    .col.pl-2
                      b-form-group#input-group-2(label='Last Name:' label-for='input-2')
                        b-form-input#input-2(v-model='form.lastName' type='text' placeholder='Last Name' min="3" required)
                  b-form-group#input-group-3(label='Email:' label-for='input-3')
                    b-form-input#input-3(v-model='form.email' type='email' placeholder='Email' required)
                    .invalid-feedback.d-block(v-if="errors['user.email']") This email {{ errors['user.email'][0] }}
                  b-form-group#input-group-4(label='Password:' label-for='input-4')
                    b-form-input#input-4(v-model='form.password' type='password' placeholder='Password' required)
                    .invalid-feedback.d-block(v-if="errors['user.password']") 'Password' {{ errors['user.password'][0] }}
                  b-form-group#input-group-5(label='Repeat Password:' label-for='input-5')
                    b-form-input#input-5(v-model='form.passwordConfirm' type='password' placeholder='Repeat Password' required)
                    .invalid-feedback.d-block(v-if="errors.passwordConfirm") {{ errors.passwordConfirm }}
                  b-form-group
                    p By signing up, I accept the&nbsp;
                      a.link(href="#") Complect Terms of Use&nbsp;
                      | and acknowledge the&nbsp;
                      a.link(href="#") Privacy Policy
                  b-button.w-100(type='submit' variant='dark') Sign Up
                  hr
                  b-form-group.text-center
                    p Already have a Complect account?&nbsp;
                      a.link(href="/users/sign_in") Sign In
            #step2.form(v-if='!loading' :class="step2 ? 'd-block' : 'd-none'")
              // OtpConfirm(@otpSecretConfirmed="otpConfirmed", :userId="userId", :form="form")
              h1.text-center Confirm Your Email!
              p.text-center We sent a 6 digit code to {{ form.email }}. Please enter it below.
              div
                b-form(@submit='onSubmitStep2' @keyup="onCodeChange" v-if='show' autocomplete="off")
                  b-form-group
                    .col.text-center
                      img(src='@/assets/mail.svg' width="180" height="110")
                  b-form-group
                    .row
                      .col-12.mx-0
                        .d-flex.justify-content-space-around.mx-auto
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
                  b-button.w-100.mb-2(type='submit' variant='dark' ref="codesubmit") Submit
                  b-form-group
                    .row
                      .col-12.text-center
                        button.btn.link(type="button" @click.stop="resendOTP" :disabled="disabled") Resend code
            #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
              h1.text-center You successfuly registered!
              p.text-center You will be redirect to finish steps for updating your account
                b-icon.ml-2(icon="circle-fill" animation="throb" font-scale="1")
              .text-center
                ion-icon(name="checkmark-circle-outline")
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../components/TopNavbar";
  import BusinessPage from "./Onboarding/Business/BusinessPage";
  import SpecialistPage from "./Onboarding/Specialist/SpecialistPage";
  import OtpConfirm from "../components/OtpConfirm";

  // const random = Math.floor(Math.random() * 1000);

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'timezones'],
    components: {
      TopNavbar,
      Loading,
      BusinessPage,
      SpecialistPage,
      OtpConfirm
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: '',
        form: {
          firstName: ``,
          lastName: ``,
          email: ``,
          password: '',
          passwordConfirm: '',
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
        errors: {},
        step0: true,
        step1: false,
        step2: false,
        step3: false,
        childDataLoaded: false,
        childdata : [],
        component: '',
        seat_id: 1,
        disabled: false,
      }
    },
    methods: {
      selectType(type){
        this.userType = type
      },
      onSubmit0(event){
        event.preventDefault()
        if (!this.userType) return

        // open step 1
        this.step0 = false
        this.step1 = true
      },
      onSubmit1(event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        if (this.form.password !== this.form.passwordConfirm) {
          this.errors = { passwordConfirm : 'Password does not match'}
          // this.toast('Error', `Password does not match`)
          return
        }

        let dataToSend;

        // FOR BUSSINES
        if (this.userType === 'business') {
          dataToSend = {
            "business": {
              "contact_first_name": this.form.firstName,
              "contact_last_name": this.form.lastName,
              "user_attributes": {
                "email": this.form.email,
                "password": this.form.password
              }
            }
          }
        }
        // FOR SPECIALIST
        if (this.userType === 'specialist') {
          dataToSend = {
            "specialist": {
              "first_name": this.form.firstName,
              "last_name": this.form.lastName,
              "user_attributes": {
                "email": this.form.email,
                "password": this.form.password
              }
            }
          }
        }

        // NEED FIX AND TRACE
        // this.userType = 'seat'
        if (this.userType === 'seat') {
          dataToSend = {
            seat_id: this.seat_id,
            "seat": {
              "first_name": this.form.firstName,
              "last_name": this.form.lastName,
              "user_attributes": {
                "email": this.form.email,
                "password": this.form.password
              }
            },
          }
        }

        this.$store.dispatch('signUp', dataToSend)
          .then((response) => {
            if (response.errors) {
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                // this.toast('Error', `Form has errors! Please recheck fields! ${error}`)
              }
            }
            if (!response.errors) {
              this.userId = response.userid
              this.toast('Success', `${response.message}`)

              // open step 2
              this.step1 = false
              this.step2 = true
            }
          })
          // .catch((error) => this.toast('Error', `Couldn't submit form! ${error}`))
      },
      otpConfirmed(value) {
        console.log(value)
      },
      onSubmitStep2(event) {
        if (event) event.preventDefault()
        // clear errors
        this.errors = []

        if(this.form2.code.length !== 6) {
          this.toast('Error', `Code length incorrect!`)
          return
        }

        const dataToSend = {
          // userId: this.userId,
          email: this.form.email,
          otp_secret: this.form2.code
        }

        this.$store.dispatch('confirmEmail', dataToSend)
          .then((response) => {
            if(!response.token) {
              this.errors = {code: response.message}
              // this.toast('Error', `Errors ${response.message}`)
            }

            if(response.token) {
              // this.toast('Success', `${response.message}`)
              // localStorage.setItem('app.currentUser', JSON.stringify(response.token));
              // this.$store.commit('updateToken', response.token)

              // open step 3
              this.step2 = false
              this.step3 = true

              // Fetch data and show correct component to continue sign up
              this.fetchINitData(response)

              // Redirect to finish steps
              // setTimeout(() => {
              //   if (this.userType === 'business') window.location.href = `${window.location.origin}/businesses/new`
              //   if (this.userType === 'specialist') window.location.href = `${window.location.origin}/specialists/new`
              // }, 5000)
            }
          })
          // .catch((error) => this.toast('Error', `Couldn't submit form! ${error}`))
          .catch((error) => console.error(`${error}`))
      },
      onCodeChange(e){
        this.errors = []

        // CATCH COPY PASTE CASE
        if (e.target.value.length === 6) {
          for(let i=1; i <= 6; i++) {
            this.form2['codePart'+i] = e.target.value.charAt(i-1)
          }
        }

        if (e.keyCode === 8 || e.keyCode === 46) {
          // BACKSPACE === 8 DELETE === 46
          e.preventDefault();
          e.target.value = ''
          e.target.previousElementSibling?.focus()
          return
        }

        if (e.target.value.length < 6 && (e.keyCode >= 48) && (e.keyCode <= 57) || (e.keyCode >= 96) && (e.keyCode <= 105)) {
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
          .then((response) => this.toast('Success', `${response.message}`))
          .catch((error) => this.toast('Error', `${error.message}`))
      },

      fetchINitData(data){
        if (this.userType === 'business') {
          this.component = BusinessPage;
        }
        if (this.userType === 'specialist') {
          this.component = SpecialistPage;
        }

        //fetch from server then
        this.childdata = data;
        this.childDataLoaded = true;
      }
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

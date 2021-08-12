<template lang="pug">
  .card.registration
    .card-body.white-card-body
      #step0.form(:class="step0 ? 'd-block' : 'd-none'")
        .registration-welcome
          h1.registration__title Let's get you started!
          p.registration__subtitle Select your account type
        div
          b-form(@submit='onSubmit0' v-if='show')
            b-form-group.mb-0
              .row
                .col-sm-6.col-12.pr-md-2.text-center.mb-sm-0.mb-3
                  .account-select(@click="selectType('business')" :class="userType === 'business' ? 'active' : ''")
                    h3.account-select__title.mb-3 I am a business
                    img.account-select__img(src='@/assets/business-outline.svg' width="50" height="50")
                    p.account-select__subtitle Looking to effectively manage my compliance program and find expertise
                .col-sm-6.col-12.pl-md-2.text-center
                  .account-select(@click="selectType('specialist')" :class="userType === 'specialist' ? 'active' : ''")
                    h3.account-select__title.mb-3 I am a specialist
                    img.account-select__img(src='@/assets/briefcase-outline.svg' width="50" height="50")
                    p.account-select__subtitle Looking to work with potential clients on compliance projects
            b-button.registration__btn.w-100.mb-2(type='submit' variant='dark') Next
      #step1.form(:class="step1 ? 'd-block' : 'd-none'")
        .registration-welcome
          h1.registration__title Let's get you started!
          p.registration__subtitle Create your FREE account
        div
          b-form(@submit='onSubmit' v-if='show')
            b-alert.m-b-20(v-if="error" variant="danger" show) {{ error }}
            .row
              .col-md-6.pr-md-2
                b-form-group#input-group-1.m-b-20(label='First Name:' label-for='input-1')
                  b-form-input#input-1(v-model='form.firstName' type='text' placeholder='First Name' :class="{'is-invalid': errors.contact_first_name }")
                  Errors(:errors="errors.contact_first_name")
              .col-md-6.pl-md-2
                b-form-group#input-group-2.m-b-20(label='Last Name:' label-for='input-2')
                  b-form-input#input-2(v-model='form.lastName' type='text' placeholder='Last Name' :class="{'is-invalid': errors.contact_last_name }")
                  Errors(:errors="errors.contact_last_name")
            b-form-group#input-group-3.m-b-20(label='Email:' label-for='input-3')
              b-form-input#input-3(v-model='form.email' type='text' placeholder='Email' :class="{'is-invalid': errors['user.email'] }")
              Errors(:errors="errors['user.email']")
            b-form-group#input-group-4.m-b-20(label='Password:' label-for='input-4')
              b-form-input#input-4(v-model='form.password' type='password' placeholder='Password' :class="{'is-invalid': errors['user.password'] }")
              Errors(:errors="errors['user.password']")
            b-form-group#input-group-5.m-b-20(label='Repeat Password:' label-for='input-5')
              b-form-input#input-5(v-model='form.passwordConfirm' type='password' placeholder='Repeat Password' :class="{'is-invalid': errors.passwordConfirm }")
              Errors(:errors="errors.passwordConfirm")
            b-form-group.paragraph.m-b-10
              p By signing up, I accept the&nbsp;
                a.link(href="#") Complect Terms of Use&nbsp;
                | and acknowledge the&nbsp;
                a.link(href="#") Privacy Policy
            b-button.registration__btn.m-b-20.w-100(type='submit' variant='dark') Sign Up
    .card-footer
      b-form-group.text-center.mb-0
        p.mb-0 Already have a Complect account?&nbsp;
          router-link.link(to='/users/sign_in') Sign In
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../components/TopNavbar";
  import BusinessPage from "./Onboarding/Business/BusinessPage";
  import SpecialistPage from "./Onboarding/Specialist/SpecialistPage";
  import OtpConfirm from "../components/OtpConfirm";

  const initialForm = () => ({
    firstName: ``,
    lastName: ``,
    email: ``,
    password: '',
    passwordConfirm: '',
  })

  //validate Email
  function validateEmail($email) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    return emailReg.test($email);
  }

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
        form: initialForm(),
        show: true,
        error: '',
        errors: {},
        step0: true,
        step1: false,
        seat_id: 1,
      }
    },
    methods: {
      selectType(type){
        this.userType = type
        localStorage.setItem('app.currentUser.userType', JSON.stringify(type))
        this.$store.commit('changeUserType', type)
      },
      onSubmit0(event){
        event.preventDefault()
        if (!this.userType) return

        // open step 1
        this.step0 = false
        this.step1 = true
      },
      onSubmit(event) {
        event.preventDefault()
        // CLEAR ERRORS
        this.error = ''
        for (let value in this.errors) delete this.errors[value];

        // if (!this.form.firstName) Object.assign(this.errors, { firstName: 'Field empty' })
        // if (!this.form.lastName) Object.assign(this.errors, { lastName: 'Field empty' })
        // if (!this.form.email) Object.assign(this.errors, { email: 'Field empty' })
        // if (!this.form.password) Object.assign(this.errors, { password: 'Field empty' })
        // if (!this.form.passwordConfirm) Object.assign(this.errors, { passwordConfirm: 'Field empty' })
        if (this.form.email && !validateEmail(this.form.email)) {
          Object.assign({}, this.errors, { email: 'Email not valid' })
          // return
        }
        if (this.form.password !== this.form.passwordConfirm) {
          this.errors = { passwordConfirm : ['Password does not match'] }
          return
        }

        this.form.email = this.form.email.toLowerCase()

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
          .then(response => {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors[this.userType])) {
                this.errors = Object.assign({}, this.errors, {[key]: value})
              }
            }
            if (!response.errors) {
              this.userId = response.userid
              // OPEN OTP
              this.$router.push({ name: 'verification', params: {form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified }})
              this.toast('Success', `${response.message}`)
            }
          })
          .catch(error => console.error(error) )
      },

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    watch: {
      email (newValue, oldValue) {
        newValue.toLowerCase()
      },
    }
  }
</script>

<style module>
  @import "../styles.css";
</style>

<template lang="pug">
  .card.registration
    .card-body.white-card-body
      .form
        .registration-welcome
          h1.registration__title Let's get you started!
        div
          b-alert.m-b-20(v-if="error" variant="danger" show) {{ error }}
          b-form(@submit='onSubmit' v-if='show')
            b-form-group#input-group-1.m-b-20(label='Email:' label-for='input-1')
              b-form-input#input-1(v-model='form.email' type='text' placeholder='Email' :class="{'is-invalid': errors.email }")
              .invalid-feedback.d-block(v-if="errors.email") {{ errors.email }}
            b-form-group#input-group-2.m-b-20(label='Password:' label-for='input-2')
              b-form-input#input-2(v-model='form.password' type='password' placeholder='Password' :class="{'is-invalid': errors.password }")
              .invalid-feedback.d-block(v-if="errors.password") {{ errors.password }}
            b-button.m-b-20.w-100(type='submit' variant='dark') Sign In
            b-form-group.text-center.forgot-password.mb-0
              router-link.link.o-8.forgot-password(to='/users/password/new') Forgot Password
    .card-footer
      b-form-group.text-center.mb-0
        p.mb-0 Don't have an account yet?&nbsp;
          router-link.link(to='/users/sign_up') Sign up
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "../components/TopNavbar";

  /* Will be deleted soon after we test it on staging */
  console.warn("process.env.STRIPE_PUBLISHABLE_KEY > ", process.env.STRIPE_PUBLISHABLE_KEY)
  console.warn("process.env.PLAID_PUBLIC_KEY > ", process.env.PLAID_PUBLIC_KEY)

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
    components: {
      TopNavbar,
      Loading,
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
        emailVerified: true,
      }
    },
    methods: {
      selectType(type){
        this.userType = type
      },
      onSubmit(event) {
        event.preventDefault()
        // CLEAR ERRORS
        this.error = ''
        for (var value in this.errors) delete this.errors[value];

        if (!this.form.email) Object.assign({}, this.errors, { email: 'Field empty' })
        if (!this.form.password) Object.assign({}, this.errors, { password: 'Field empty' })
        if (this.form.email && !validateEmail(this.form.email)) {
          Object.assign({}, this.errors, { email: 'Email not valid' })
          return
        }

        this.form.email = this.form.email.toLowerCase() // Avoid issues with Capitalized emails
        const data = {
          user: {
            email: this.form.email,
            password: this.form.password
          },
        }
        this.$store.dispatch('signIn', data)
          .then(response => {
            if (response.errors) {
              if (response.errors === 'Invalid email or password') {
                this.error = response.errors
              }
              if (response.error === 'Please, confirm your email' || response.errors === 'Please, confirm your email') {
                this.emailVerified = false
                // OPEN OTP
                this.$router.push({ name: 'otp-confirm', params: {form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified }})
                let data = {
                  user: {
                    email: this.form.email,
                  },
                }
                this.$store.dispatch('resendOTP', data)
                  .then((response) => this.$router.push({ name: 'otp-confirm', params: {form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified }}) )
                  .catch((error) => console.error(error))
              }
            }
            if (!response.errors) {
              // OPEN OTP CONFIRM
              this.$router.push({ name: 'otp-confirm', params: {form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified }})
            }
          })
          .catch(error => {
            if (error.errors === 'Invalid email or password.' || error.errors.invalid === 'Invalid email or password.') {
              this.error = error.errors.invalid
            }
            console.log(error)
          })
      },
      onOTPConfirm(event) {
        event.preventDefault()
        this.errors = []

        if(this.form2.code.length !== 6) {
          this.toast('Error', `Code length incorrect!`)
          return
        }

        // IF UNVERIFIED EMAIL
        if(!this.emailVerified) {
          const dataToSend1 = {
            email: this.form.email,
            otp_secret: this.form2.code
          }

          this.$store.dispatch('confirmEmail', dataToSend1)
            .then((response) => {
              console.log('response', response)
              if (response.errors) {
                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                  this.errors.code = response.errors[type]
                }
              }
              if (!response.errors && response.token) {
                // OPEN DASHBOARD
                const dashboard = response.business ? '/business' : '/specialist'
                window.location.href = `${dashboard}`;
              }
            })
            .catch(error => console.error(error))
        }

        // IF VERIFIED EMAIL
        if(this.emailVerified) {
        const dataToSend = {
          "user": {
            email: this.form.email,
            password: this.form.password
          },
          otp_secret: this.form2.code
        }

        this.$store.dispatch('signIn', dataToSend)
          .then((response) => {
            console.log('response', response)
            if (response.errors) {
              for (const type of Object.keys(response.errors)) {
                this.errors = response.errors[type]
                this.errors.code = response.errors[type]
              }
            }

            if (!response.errors && response.token) {
              // OPEN DASHBOARD
              const dashboard = response.business ? '/business' : '/specialist'
              window.location.href = `${dashboard}`;
            }
          })
          .catch(error => {
            if (error.data.errors) {
              this.errors.code = error.data.errors.invalid
            }
          })
        }
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

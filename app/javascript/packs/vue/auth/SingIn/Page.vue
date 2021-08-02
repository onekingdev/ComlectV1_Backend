<template lang="pug">
  .card.registration
    .card-body.white-card-body
      .form
        .registration-welcome
          h1.registration__title Let's get you started!
        div
          .invalid-feedback.d-block.text-center.m-b-20(v-if="error") {{ error }}
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
        step1: true,
        step2: false,
        step3: false,
        emailVerified: true,
      }
    },
    methods: {
      selectType(type){
        this.userType = type
      },
      otpConfirmed() {
        this.step1 = false
        this.step2 = true
      },
      onSubmit(event) {
        event.preventDefault()
        // clear errors
        this.error = ''
        this.errors = []

        if (!this.form.email) Object.assign(this.errors, { email: 'Field empty' })
        if (this.form.email && !validateEmail(this.form.email)) Object.assign(this.errors, { email: 'Email not valid!' })
        if (!this.form.password) Object.assign(this.errors, { password: 'Field empty' })

        console.log(validateEmail(this.form.email))

        this.form.email = this.form.email.toLowerCase()
        const data = {
          user: {
            email: this.form.email,
            password: this.form.password
          },
        }
        console.log('data', data)
        this.$store.dispatch('signIn', data)
          .then(response => {
            if (response.errors) {
              console.log('response.signIn', response)
              if (response.errors === 'Invalid email or password') {
                this.error = response.errors
              }
              if (response.error === 'Please, confirm your email' || response.errors === 'Please, confirm your email') {
                this.emailVerified = false

                // this.step1 = false
                // this.step2 = true
                this.$router.push({ name: 'otp-confirm', params: {form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified }})

                let data = {
                  user: {
                    email: this.form.email,
                  },
                }

                console.log('data2', data)

                this.$store.dispatch('resendOTP', data)
                  .then((response) => {
                    console.log('response.resendOTP', response)
                    this.$router.push({ name: 'otp-confirm', params: {form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified }})
                  })
                  .catch((error) => {
                    console.error('error.resendOTP', error)
                  })
              }
            }
            if (!response.errors) {
              // this.toast('Success', `${response.message}`)
              // open step 2
              // this.step1 = false
              // this.step2 = true
              // this.$router.push('/otp-confirm')
              // this.$router.push({ path: '/otp-confirm', params: {form: this.form }})
              console.log({form: this.form, userid: this.userid, userType: this.userType, emailVerified: this.emailVerified })
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

        console.log('emailVerified', this.emailVerified)

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
                // open step 3
                this.step2 = false
                this.step3 = true

                // this.toast('Success', `You will be redirect to the dashboard!`)

                const dashboard = response.business ? '/business' : '/specialist'
                setTimeout(() => {
                  window.location.href = `${dashboard}`;
                }, 3000)
              }
            })
            .catch((error) => {
              // this.toast('Error', `${error.message}`)
            })
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
              // open step 3
              this.step2 = false
              this.step3 = true

              // this.toast('Success', `You will be redirect to the dashboard!`)

              const dashboard = response.business ? '/business' : '/specialist'
              setTimeout(() => {
                window.location.href = `${dashboard}`;
              }, 3000)
            }
          })
          .catch((error) => {
            console.error('error', error.data)
            console.error('error', error.data.errors)
            console.error('error', error.data.errors.invalid)
            if (error.data.errors) {
              this.errors.code = error.data.errors.invalid
            }
          })
        }
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
          this.onOTPConfirm(e)
        }
      },

      resendOTP() {
        let dataToSend = {
          "user": {
            "email": this.form.email,
          },
        }

        this.$store.dispatch('resendOTP', dataToSend)
          .then((response) => {
            // this.toast('Success', `${response.message}`)
          })
          .catch((error) => {
            // this.toast('Error', `${error.message}`)
          })
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

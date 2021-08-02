<template lang="pug">
  .card.registration
    .card-body.white-card-body
      .registration-welcome
        h1.registration__title Confirm Your Email
        p.registration__subtitle We sent a 6 digit code to {{ form.email }}. Please enter it below.
      div
        b-form(@submit='onSubmit' @keyup="onCodeChange" v-if='show' autocomplete="off")
          b-form-group
            .col.text-center
              img.otp-icon(src='@/assets/mail.svg' width="180" height="110")
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
                .invalid-feedback.d-block.text-center(v-if="error") {{ error }}
            .row
              .col
                input(v-model='form2.code' type='hidden')
          b-button.w-100.mb-3(type='submit' variant='dark' ref="codesubmit") Submit
          .card-footer
            b-form-group.mb-0
              .row
                .col-12.text-center
                  a.link(@click.stop="resendOTP" :disabled="disabled") Resend code
</template>

<script>
  export default {
    props: ['form', 'userid', 'userType', 'emailVerified'],
    data() {
      return {
        show: true,
        error: '',
        errors: {},
        form2: {
          codePart1: '',
          codePart2: '',
          codePart3: '',
          codePart4: '',
          codePart5: '',
          codePart6: '',
          code: '',
        },
        disabled: false,
        dismissSecs: 8,
        dismissCountDown: 0,
        showDismissibleAlert: false,
      }
    },
    methods: {
      onSubmit(event) {
        event.preventDefault()
        this.error = ''
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

          console.log('dataToSend1 !this.emailVerified', dataToSend1)

          this.$store.dispatch('confirmEmail', dataToSend1)
            .then((response) => {
              console.log('response', response)
              if (response.errors) {

              }
              if (!response.errors && response.token) {
                // open step 3
                // this.step2 = false
                // this.step3 = true

                const dashboard = response.business ? '/business' : '/specialist'
                // window.location.href = `${dashboard}`;
                this.$router.push(`${dashboard}/onboarding`)
              }
            })
            .catch((error) => this.toast('Error', `${error.message}`))
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

          console.log('dataToSend this.emailVerifie', dataToSend)

          this.$store.dispatch('signIn', dataToSend)
            .then((response) => {
              console.log('response', response)
              if (response.errors) {

              }

              if (!response.errors && response.token) {
                // open step 3
                // this.step2 = false
                // this.step3 = true

                const dashboard = response.business ? '/business' : '/specialist'
                window.location.href = `${dashboard}`;
                // this.$router.push(`${dashboard}/onboarding`)
                // this.$router.push(`${dashboard}`)
              }

              this.error = response.message
            })
            .catch((error) => {
              console.error('error', error.data)
              console.error('error', error.data.errors)
              console.error('error', error.data.errors.invalid)
              if (error.data.errors) {
                this.error = error.data.errors.invalid
              }
            })
        }
      },
      onCodeChange(e){
        this.error = ''
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
          this.onSubmit(e)
        }
      },
      resendOTP() {
        const data = {
          "user": {
            "email": this.form.email,
          },
        }
        this.$store.dispatch('resendOTP', data)
          .then((response) => this.toast('Success', `${response.message}`))
          .catch((error) => this.toast('Error', `${error.status} (${error.statusText})`))
      },
      countDownChanged(dismissCountDown) {
        this.dismissCountDown = dismissCountDown
      },
      showAlert() {
        this.dismissCountDown = this.dismissSecs
      },
    },
    computed: {
      currentUser() {
        return this.$store.getters.getUser
      },
    }
  }
</script>

<style scoped>

</style>

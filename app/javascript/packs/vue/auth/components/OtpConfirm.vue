<template lang="pug">
  div
    h1.text-center Confirm Your Email!
    p.text-center We sent a 6 digit code to {{ form.email }}. Please enter it below.
    div
      b-alert(:show='dismissCountDown' dismissible fade variant='danger' @dismiss-count-down='countDownChanged')
        | {{ error }}
        br
        | This alert will dismiss after {{ dismissCountDown }} seconds...
      b-form(@submit='onSubmit' @keyup="onCodeChange" v-if='show' autocomplete="off")
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
</template>

<script>
  export default {
    props: ['form', 'userid'],
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

        if(this.form2.code.length !== 6) {
          this.toast('Error', `Code length incorrect!`)
          return
        }

        let data, method;
        if(this.userId) {
          data = {
            userId: this.userId,
            code: this.form2.code
          }
          method = 'confirmEmail'
        }
        if(!this.userId) {
          data = {
            "user": {
              "email": this.form.email,
              "password": this.form.password
            },
            "otp_secret": this.form2.code
          }
          method = 'singIn'
        }

        this.$store.dispatch(method, data)
          .then((response) => {
            console.log('response', response)
            if(response.errors) {
              // this.toast('Error', `${response.errors}`)
              this.error = `${response.message}`
            }
            if(response.token) {
              // this.toast('Success', `${response.message}`)
              this.error = `${response.message}`
              this.$emit('otpSecretConfirmed', response)
            }
          })
          .catch((error) => {
            const { data } = error
            if(data.errors) {
              for (const type of Object.keys(data.errors)) {
                // this.toast('Error', `${data.errors[type]}`)
                this.error = `Error! ${data.errors[type]}`
              }
              this.showAlert()
            }
            if (error.errors) {
              // this.toast('Error', `Couldn't submit form! ${error.message}`)
              this.error = `Error! ${data.errors[type]}`

            }
            if (!error.errors) {
              // this.toast('Error', `${error.status} (${error.statusText})`)
              this.error = `Error! ${data.errors[type]}`
            }
          })

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
      loading() {
        return this.$store.getters.loading;
      },
      currentUser() {
        return this.$store.getters.getUser
      },
    }
  }
</script>

<style scoped>

</style>

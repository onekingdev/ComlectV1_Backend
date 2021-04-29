<template lang="pug">
  div
    .container-fluid
      TopNavbar
      main.row#main-content
        .col-xl-4.col-lg-6.col-md-8.m-x-auto
          .card-body.white-card-body.registration
            Loading
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h1.text-center Change your passwod
              p.text-center Enter the new password and repeat
              div
                b-alert(:show='dismissCountDown' dismissible fade variant='danger' @dismiss-count-down='countDownChanged')
                  | {{ error }}
                  br
                  | This alert will dismiss after {{ dismissCountDown }} seconds...
                b-form(@submit='onSubmit1' v-if='show')
                  b-form-group#input-group-4(label='Password:' label-for='input-4')
                    b-form-input#input-4(v-model='form.password' type='password' placeholder='Password' required)
                    .invalid-feedback.d-block(v-if="errors.password") 'Password' {{ errors.password }}
                  b-form-group#input-group-5(label='Repeat Password:' label-for='input-5')
                    b-form-input#input-5(v-model='form.passwordConfirm' type='password' placeholder='Repeat Password' required)
                    .invalid-feedback.d-block(v-if="errors.passwordConfirm") {{ errors.passwordConfirm }}
                  b-button.w-100(type='submit' variant='dark') Save
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

  const random = Math.floor(Math.random() * 1000);

  export default {
    components: {
      Loading,
      TopNavbar,
    },
    created() {
      const url = new URL(window.location);
      const resetPasswordToken = url.searchParams.get('reset_password_token');
      this.resetPasswordToken = resetPasswordToken;
      console.log('resetPasswordToken', this.resetPasswordToken)
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: '',
        form: {
          password: '',
          passwordConfirm: '',
        },
        show: true,
        error: '',
        errors: {},
        step1: true,
        step2: false,
        dismissSecs: 8,
        dismissCountDown: 0,
        showDismissibleAlert: false,
        resetPasswordToken: '',
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

        if (this.form.password !== this.form.passwordConfirm) {
          this.errors = { passwordConfirm : 'Passwords are different!'}
          this.makeToast('Error', `Passwords are different!`)
          return
        }

        let dataToSend;

        dataToSend = {
          "user": {
            "reset_password_token": this.resetPasswordToken,
            "password": this.form.password,
            "password_confirmation": this.form.passwordConfirm
          }
        }

        this.$store.dispatch('changeEmail', dataToSend)
          .then((response) => {

            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                console.log(`${key}: ${value}`);
                this.makeToast('Error', `${key}: ${value}`)
                this.errors = Object.assign(this.errors, { [key]: value })
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

            setTimeout(() => {
              window.location.href = `/users/sign_in`;
            }, 6000)
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

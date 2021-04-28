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
                  b-form-group.text-center
                    p Forget your password?&nbsp;
                      a.link(href="#") Restore
                b-card.mt-3(header='Form Data Result')
                  pre.m-0 {{ form }}
            #step2.form(v-if='!loading' :class="step2 ? 'd-block' : 'd-none'")
              h1.text-center Confirm your email!
              p.text-center We send a 6 digit code to email.com. Please enter it below.
              div
                b-form(@submit='onSubmitStep2' @keyup="onChange" v-if='show' autocomplete="off")
                  b-form-group
                    .col.text-center
                      ion-icon(name="mail-outline" size="large")
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
                  b-button.w-100(type='submit' variant='dark') Submit
                b-card.mt-3(header='Form Data Result')
                  pre.m-0 {{ form2 }}
            #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
              h1.text-center You successfuly logged in!
              p.text-center You will be redirect to the dashboard!
              .text-center
                b-icon( icon="circle-fill" animation="throb" font-scale="4")
                  <!--ion-icon(name="checkmark-circle-outline" size="large")-->
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
    created() {
    //   const urlUserId = location.search.split('userid=')[1]
    //   if(urlUserId) this.userId = urlUserId
    //   const otpSecret = location.search.split('otp_secret=')[1]
    //   if(otpSecret) this.otpSecret = otpSecret

      // const currentUserLocalStorage = localStorage.getItem('app.currentUser') ? localStorage.getItem('app.currentUser') : '';
      // if (currentUserLocalStorage) {
      //   const currentUser = JSON.parse(currentUserLocalStorage);
      //   this.userId = currentUser.userid;
      // }
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

        console.log('dataToSend', dataToSend)

        this.$store.dispatch('singIn', dataToSend)
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
            console.log('response', response)

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

              // open step 3
              this.step2 = false
              this.step3 = true
            }


            if (response.token) {
              const dashboard = response.business ? '/business2' : '/specialist'
              setTimeout(() => {
                window.location.href = `${dashboard}`;
              }, 3000)
            }
          })
          .catch((error) => this.makeToast('Error', `Couldn't submit form! ${error}`))
      },
      onChange(e){
        this.errors = []

        if (e.target.value.length === 1) {
          e.target.nextElementSibling?.focus()
        }

        // CATCH COPY PASTE CASE
        if (e.target.value.length > 1) {
          for(let i=1; i <= 6; i++) {
            this.form2['codePart'+i] = e.target.value.charAt(i-1)
          }
        }

        this.form2.code = this.form2.codePart1 + this.form2.codePart2 + this.form2.codePart3 + this.form2.codePart4 + this.form2.codePart5 + this.form2.codePart6
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

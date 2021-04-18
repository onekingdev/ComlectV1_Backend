<template lang="pug">
  .col-xl-4.col-lg-6.col-md-8.m-x-auto
    .card-body.white-card-body.registration
      Loading
      #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
        h1.text-center Let's get you started!
        p.text-center Create your FREE account
        div
          b-form(@submit='onSubmit' v-if='show')
            .row
              .col.pr-2
                b-form-group#input-group-1(label='First Name:' label-for='input-1')
                  b-form-input#input-1(v-model='form.firstName' type='text' placeholder='First Name' min="3" required)
              .col.pl-2
                b-form-group#input-group-2(label='Last Name:' label-for='input-2')
                  b-form-input#input-2(v-model='form.lastName' type='text' placeholder='Last Name' min="3" required)
            b-form-group#input-group-3(label='Email:' label-for='input-3')
              b-form-input#input-3(v-model='form.email' type='email' placeholder='Email' required)
              .invalid-feedback.d-block(v-if="errors['user.email']") 'Email' {{ ...errors['user.email'] }}
            b-form-group#input-group-4(label='Password:' label-for='input-4')
              b-form-input#input-4(v-model='form.password' type='password' placeholder='Password' required)
              .invalid-feedback.d-block(v-if="errors['user.password']") 'Password' {{ ...errors['user.password'] }}
            b-form-group#input-group-5(label='Repeat Password:' label-for='input-5')
              b-form-input#input-5(v-model='form.passwordConfirm' type='password' placeholder='Repeat Password' required)
              .invalid-feedback.d-block(v-if="errors['user.passwordConfirm']") 'Repeat Password' {{ ...errors['user.passwordConfirm'] }}
            b-form-group
              p By sining up, I accept the&nbsp;
                a.link(href="#") Complect Term of Service&nbsp;
                | and acknowledge the&nbsp;
                a.link(href="#") Privacy Policy
            b-button.w-100(type='submit' variant='dark') Sign Up
            hr
            b-form-group.text-center
              p Already have a Complect account?&nbsp;
                a.link(href="#") Sign Up
          b-card.mt-3(header='Form Data Result')
            pre.m-0 {{ form }}
      #step2.form(v-if='!loading'  :class="step2 ? 'd-block' : 'd-none'")
        h1.text-center Confirm your email!
        p.text-center We send a 6 digit code to email.com. Please enter it below.
        div
          b-form(@submit='onSubmitStep2' @change="onChange" v-if='show')
            b-form-group
              .col-lg-2.m-x-auto
                ion-icon(name="mail-outline" size="large")
            b-form-group
              .row
                .col-12.mx-0
                  .d-flex.justify-content-space-around.mx-auto.w-50
                    b-form-input#inputCode1.code-input(v-model='form2.codePart1' type='text' required)
                    b-form-input#inputCode2.code-input(v-model='form2.codePart2' type='text' required)
                    b-form-input#inputCode3.code-input(v-model='form2.codePart3' type='text' required)
                    b-form-input#inputCode4.code-input(v-model='form2.codePart4' type='text' required)
                    b-form-input#inputCode5.code-input(v-model='form2.codePart5' type='text' required)
                    b-form-input#inputCode6.code-input(v-model='form2.codePart6' type='text' required)
              .row
                .col
                  input(v-model='form2.code' type='hidden')
                  .invalid-feedback.d-block(v-if="errors.code") {{ errors.code }}
            b-button.w-100(type='submit' variant='dark') Submit
          b-card.mt-3(header='Form Data Result')
            pre.m-0 {{ form2 }}
      #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
        h1.text-center You successfuly registered!
        p.text-center You will be redirect to finish steps for updating your account
        .text-center
            ion-icon(name="checkmark-circle-outline" size="large")
</template>

<script>
  import Loading from '@/common/Loading/Loading'

  export default {
    components: {
      Loading,
    },
    data() {
      return {
        userId: '',
        form: {
          firstName: 'Alex2',
          lastName: 'GangBang',
          email: 'fine@email.com',
          password: 'user666',
          passwordConfirm: 'user666',
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
        step1: true,
        step2: false,
        step3: false,
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      etValidationState({ dirty, validated, valid = null }) {
        return dirty || validated ? valid : null;
      },
      onSubmit(event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        const dataToSend = {
          "business": {
            "contact_first_name": this.form.firstName,
            "contact_last_name": this.form.lastName,
            "user_attributes": {
              "email": this.form.email,
              "password": this.form.password
            }
          }
        }
        console.log('dataToSend', dataToSend)
        this.$store.dispatch('singUp', dataToSend)
          .then((response) => {
            console.log('response 222', response)
            if (response.errors) {

              const properties = Object.keys(response.errors);
              console.log('properties', properties);

              for (const type of Object.keys(response.errors)) {
                console.log('err', type);
                console.log('err2222', response.errors[type]);
                this.errors = response.errors[type]

                this.makeToast('Error', `Form has errors! Please recheck fields! ${error}`)

                // Object.keys(response.errors[type]).map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
              }

              return
            }

            if (!response.errors) {
              this.userId = response.userid
              this.makeToast('Success', `${response.message}`)

                // ?userid=14&otp_secret=123456
              const url = new URL(window.location);
              url.searchParams.set('userid', response.userid);
              window.history.pushState({}, '', url);

              // open step 2
              this.step1 = false
              this.step2 = true
            }
          })
          .catch((error) => this.makeToast('Error', `Couldn't submit form! ${error}`))
      },
      onSubmitStep2(event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        const urlUserId = location.search.split('userid=')[1]
        if(urlUserId) this.userId = urlUserId

        const dataToSend = {
          userId: this.userId,
          code: this.form2.code
        }
        console.log('dataToSend', dataToSend)

        this.$store.dispatch('confirmEmail', dataToSend)
          .then((response) => {
            console.log('response 222', response)

            if(response.errors) {
              this.errors.code = response.message
              this.makeToast('Error', `Errors ${response.message}`)
              return
            }

            if(!response.errors) {
              this.makeToast('Success', `${response.message}`)
              localStorage.setItem('app.currentUser', JSON.stringify(response.token));
              this.$store.commit('updateToken', response.token)

              // open step 3
              this.step2 = false
              this.step3 = true
            }

          })
          .catch((error) => this.makeToast('Error', `Couldn't submit form! ${error}`))
      },
      onChange(e){
        this.form2.code = this.form2.codePart1 + this.form2.codePart2 + this.form2.codePart3 + this.form2.codePart4 + this.form2.codePart5 + this.form2.codePart6
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
  .registration {
    margin-top: 10rem;
  }
  @media (min-width: 576px) and (max-width: 767px) {
    .registration {
      margin-top: 3rem;
    }
  }
  @media (max-width: 575px) {
    .registration {
      margin-top: 1rem;
    }
  }
  .link{
    color: var(--blue)
  }

  ion-icon {
    font-size: 64px;
  }

  .code-input {
    width: 3rem;
    height: 5rem;
    margin-right: .5rem;
    text-align: center;
  }
</style>

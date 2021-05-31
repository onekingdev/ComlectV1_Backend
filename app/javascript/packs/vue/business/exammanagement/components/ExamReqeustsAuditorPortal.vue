<template lang="pug">
  div
    Loading
    #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
      .row
        .col-xl-6.col-lg-8.col.m-x-auto
          .card-body.white-card-body.reviews__card.px-5.registration
            h1.text-center Confirm your email!
            // p.text-center Enter to the system
            div
              b-alert(:show='dismissCountDown' dismissible fade variant='danger' @dismiss-count-down='countDownChanged')
                | {{ error }}
                br
                | This alert will dismiss after {{ dismissCountDown }} seconds...
              b-form(@submit='onSubmit1' v-if='show')
                b-form-group#input-group-1(label='Email:' label-for='input-1')
                  b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required)
                  .invalid-feedback.d-block(v-if="errors.email") {{ errors.email }}
                b-button.w-100(type='submit' variant='dark') Confirm
    #step2.form(v-if='!loading' :class="step2 ? 'd-block' : 'd-none'")
      .row
        .col-xl-6.col-lg-8.col.m-x-auto
          .card-body.white-card-body.reviews__card.registration.px-5.mt-0
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
    #step3.card-body.white-card-body.reviews__card.px-5(v-if='!loading && currentExam'  :class="step3 ? 'd-block' : 'd-none'")
      .reviews__card--internal.d-flex.justify-content-between.p-y-1.m-b-2
        h3 Shared with me
      .reviews__topiclist
        template(v-if="currentExam.exam_requests" v-for="(currentRequst, i) in currentExam.exam_requests")
          .reviews__card--internal.exams__card--internal(:key="`${currentExam.name}-${i}`")
            .row.m-b-1
              .col
                .d-flex.justify-content-between.align-items-center
                  .d-flex
                    b-badge.mr-2(v-if="currentRequst.shared" variant="success") {{ currentRequst.shared ? 'Shared' : '' }}
                    .exams__input.exams__topic-name {{ currentRequst.name }}
            .row.m-b-1
              .col-md-11
                p {{ currentRequst.details }}
            .row.m-b-1
              .col-md-11
                .row
                  .col
                    .d-flex.justify-content-between.align-items-center
                      span
                        b-icon.mr-2(:icon="currentRequst.text_items && currentRequst.text_items.length ? 'chevron-down' : 'chevron-right'")
                        | {{ currentRequst.text_items && currentRequst.text_items.length ? currentRequst.text_items.length : 0 }} Items
                hr(v-if="currentRequst.text_items")
                .row(v-if="currentRequst.text_items")
                  template(v-for="(textItem, textIndex) in currentRequst.text_items")
                    .col-12.exams__text(:key="`${currentRequst.name}-${i}-${textItem}-${textIndex}`")
                      .row
                        .col.m-b-1 {{ currentRequst.text_items[textIndex].text }}
                .row
                  template(v-for="(file, fileIndex) in currentRequst.exam_request_files")
                    .col-md-6.m-b-1(:key="`${currentRequst.name}-${i}-${file}-${fileIndex}`")
                      .file-card
                        div.mr-2
                          b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                        div.ml-0.mr-auto
                          p.file-card__name: b {{ file.name }}
                          a.file-card__link.link(:href="file.file_url" target="_blank") Download
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  export default {
    props: ['uuid'],
    components: {Loading},
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

        const data = {
          "uuid": this.uuid,
          "email": this.form.email,
        }

        this.$store.dispatch('exams/confirmEmail', data)
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
          })
          .finally(() => {
            this.step1 = false
            this.step2 = true
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

        const data = {
          email: this.form.email,
          otp: this.form2.code
        }

        this.$store.dispatch('clearError', data)
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
              // open step 3
              this.step2 = false
              this.step3 = true
            }
          })
          .catch((error) => this.makeToast('Error', `Couldn't submit form! ${error}`))
          .finally(() => {
            this.step2 = false
            this.step3 = true
          })
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
      currentExam() {
        return this.$store.getters.currentExam || {};
      }
    },
  }
</script>

<style scoped>
  #step2 ion-icon {
    font-size: 15rem!important;
  }
</style>

<template lang="pug">
  .container-flud
    .row
      .col-12.mb-5
        .header.d-flex.justify-content-between(id='top_navbar')
          .header__logo
            img(height='48px' src='/assets/logo-b7915ac667f29762d6d3745cf555b7d2c80bf3cd90b798a32385bdf9106dc870.png')
          .header__nav
            a(href="#").btn.btn-dark Logout
    .row
      .col-md-4.m-x-auto
        .card-body.white-card-body
          form.form
            h1.text-center Let's get you started!
            p.text-center Create your FREE account
            div
            b-form(@submit='onSubmit' @reset='onReset' v-if='show')
              .row
                .col
                  b-form-group#input-group-1(label='First Name:' label-for='input-1')
                    b-form-input#input-1(v-model='form.firstName' type='email' placeholder='First Name' required)
                .col
                  b-form-group#input-group-2(label='Last Name:' label-for='input-2')
                    b-form-input#input-2(v-model='form.lastName' placeholder='Last Name' required)
              b-form-group#input-group-3(label='Email:' label-for='input-3')
                b-form-input#input-1(v-model='form.email' type='email' placeholder='Email' required)
              b-form-group#input-group-3(label='Password:' label-for='input-3')
                b-form-input#input-3(v-model='form.password' type='password' placeholder='Password' required)
              b-form-group
                p By sining up, I accept the&nbsp;
                  a(href="#") Complect Term of Service&nbsp;
                  | and acknowledge the&nbsp;
                  a(href="#") Privacy Policy
              b-button.w-100(type='submit' variant='dark') Sign Up
              hr
              b-form-group.text-center
                p Already have a Complect account?&nbsp;
                  a(href="#") Sign Up
            b-card.mt-3(header='Form Data Result')
              pre.m-0 {{ form }}
</template>

<script>
  export default {
    data() {
      return {
        form: {
          firstName: '',
          lastName: '',
          email: '',
          password: '',
        },
        show: true
      }
    },
    methods: {
      onSubmit(event) {
        event.preventDefault()
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form.firstName = ''
        this.form.lastName = ''
        this.form.email = ''
        this.form.password = ''
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      }
    }
  }
</script>

<style scoped>

</style>

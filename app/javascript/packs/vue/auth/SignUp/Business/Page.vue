<template lang="pug">
  .col-xl-4.col-lg-6.col-md-8.m-x-auto
    .card-body.white-card-body.registration
      form.form
        h1.text-center Let's get you started!
        p.text-center Create your FREE account
        div
        b-form(@submit='onSubmit' @reset='onReset' v-if='show')
          .row
            .col.pr-2
              b-form-group#input-group-1(label='First Name:' label-for='input-1')
                b-form-input#input-1(v-model='form.firstName' type='text' placeholder='First Name' required)
            .col.pl-2
              b-form-group#input-group-2(label='Last Name:' label-for='input-2')
                b-form-input#input-2(v-model='form.lastName' type='text' placeholder='Last Name' required)
          b-form-group#input-group-3(label='Email:' label-for='input-3')
            b-form-input#input-3(v-model='form.email' type='email' placeholder='Email' required)
          b-form-group#input-group-4(label='Password:' label-for='input-4')
            b-form-input#input-4(v-model='form.password' type='password' placeholder='Password' required)
          b-form-group#input-group-5(label='Repeat Password:' label-for='input-5')
            b-form-input#input-5(v-model='form.passwordConfirm' type='password' placeholder='Repeat Password' required)
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
          passwordConfirm: '',
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
</style>

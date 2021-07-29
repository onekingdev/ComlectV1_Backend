<template lang="pug">
  div
    Loading
    b-form(@submit='onSubmit' @reset='onReset' v-if='!loading && show')
      .row
        .col
          h3.mb-3 My Rate
          b-form-group#inputS-group-1.m-b-20(label='Hourly Rate' label-for='inputS-1' label-class="label required" description="Per hour")
            b-form-input#inputS-1(v-model='form.hourly_rate' type='text' placeholder='Hourly Rate' required :class="{'is-invalid': errors.business_name }")
            .invalid-feedback.d-block(v-if="errors.hourly_rate") {{ errors.hourly_rate[0] }}
      hr
      .row
        .col
          h3.onboarding__title.m-b-20 Experience Level
          b-form-group(class="onboarding-group m-b-30")
            b-button.exp__btn(variant="default" :class="form.experience === 0 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 0)")
              span.exp__btn--main Junior
              span.exp__btn--sub Beginner consultant with some industry experience.
            b-button.exp__btn(variant="default" :class="form.experience === 1 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 1)")
              span.exp__btn--main Intermediate
              span.exp__btn--sub Good experience and solid knowledge of the industry.
            b-button.exp__btn(variant="default" :class="form.experience === 2 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 2)")
              span.exp__btn--main Expert
              span.exp__btn--sub Deep understanding of industry with varied experience.
      hr
      .row
        .col
          h3.m-b-20 Name Settings
          b-form-group(v-slot='{ ariaDescribedby }')
            b-form-radio-group(v-model='form.nameSettingsSelected' :options='form.nameSettingsOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
      hr
      b-form-group.text-right
        b-button.btn(type='submit' variant='primary') Save
</template>

<script>
  import VueGoogleAutocomplete from 'vue-google-autocomplete'
  import Multiselect from 'vue-multiselect'
  import Loading from '@/common/Loading/Loading'

  const initialForm = () => ({
    hourly_rate: '',
    experience: '',
    nameSettingsSelected: '',
    nameSettingsOptions: [
      'Show my full name (ex. John Doe)',
      'Show my first name and first letter of my last (ex. John D.)'
    ],
  })

  export default {
    name: "CompanyDetails",
    components: {
      VueGoogleAutocomplete,
      Multiselect,
      Loading,
    },
    data() {
      return {
        form: initialForm(),

        show: true,
        errors: {},
        url: null,
        inputFile: null
      }
    },
    methods: {
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form = initialForm();
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      },
      onSubmit(event) {
        event.preventDefault()

        const data = {

        }

        console.log('data', data)
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

</style>

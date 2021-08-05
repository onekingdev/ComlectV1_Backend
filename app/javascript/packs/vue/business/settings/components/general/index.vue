<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 General
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4
                    b Location
            .row
              .col-md-6
                b-form(@submit='onSubmit' @reset="onReset" v-if='show')
                  b-form-group#input-group-1(label='Time Zone' label-for='select-1' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.time_zone }"
                    )
                      multiselect#select-1(
                      v-model="form.time_zone"
                      :options="options.timezones"
                      :multiple="false"
                      :show-labels="false"
                      track-by="name",
                      label="name"
                      placeholder="Select Time Zone",
                      required)
                      .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone[0] }}
                  b-form-group#input-group-2(label='Country' label-for='select-2' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.country }"
                    )
                      multiselect#select-2(
                      v-model="form.country"
                      :options="options.contries"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select Country",
                      required)
                      .invalid-feedback.d-block(v-if="errors.country") {{ errors.country[0] }}
                  b-form-group#input-group-3(label='State' label-for='select-3' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.state }"
                    )
                      multiselect#select-3(
                      v-model="form.state"
                      :options="options.states"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select State",
                      required)
                      .invalid-feedback.d-block(v-if="errors.state") {{ errors.state[0] }}
                  b-form-group#input-group-4(label='City' label-for='input-4' label-class="settings__card--label")
                    b-form-input#input-4(v-model='form.city' type='text' placeholder='City' required :class="{'is-invalid': errors.city }")
                    .invalid-feedback.d-block(v-if="errors.city") {{ errors.city[0] }}
                  b-form-group#input-group-5(label='Phone Number' label-for='input-5' label-class="settings__card--label")
                    b-form-input#input-5(v-model='form.contact_phone' type='text' placeholder='Phone Number' required :class="{'is-invalid': errors.contact_phone }")
                    .invalid-feedback.d-block(v-if="errors.contact_phone") {{ errors.contact_phone[0] }}
                  b-form-group.text-right
                    b-button.btn.btn-link.mr-2(type='reset' variant='none') Cancel
                    b-button(type='submit' variant='dark') Save
</template>

<script>
  import Multiselect from 'vue-multiselect'
  import Loading from '@/common/Loading/Loading'

  const initialForm = () => ({
    time_zone: '',
    country: '',
    state: '',
    city: '',
    contact_phone: '',
  })

  export default {
    props: ['states', 'timezones', 'contries', 'userId'],
    components: {
      Multiselect,
      Loading,
    },
    created(){
      if(this.states) this.options.states = this.states
      // if(this.timezones) this.options.timezones = this.timezones
      if(this.contries) this.options.contries = this.contries

      if(this.timezones) {
        for (const [ value, label ] of this.timezones) {
          this.options.timezones.push({
            value: value,
            name: label
          })
        }
      }
    },
    data() {
      return {
        show: true,
        form: initialForm(),
        options: {
          timezones: [],
          contries: [],
          states: [],
        },
        errors: {},
      };
    },
    methods: {
      onSubmit (event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        this.form.time_zone = this.form.time_zone.name

        this.$store.dispatch('settings/updateGeneralSettings', this.form)
          .then(response => {
            if(response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                this.toast('Error', `${key}: ${value}`)
                this.errors = Object.assign(this.errors, { [key]: value })
              }
            }
            if(!response.errors) {
              this.toast('Success', `Information successfully saved!`)

              this.form = {
                ...response,
                time_zone: {
                  value: response.time_zone,
                  name: response.time_zone
                }
              }
            }
          })
          .catch(error => this.toast('Error', `Something wrong! ${error}`) )
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form = initialForm()
        this.form.checked = []
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    async mounted () {
      try {
        await this.$store.dispatch('settings/getGeneralSettings')
          .then(response => {
            this.form = {
              ...response,
              time_zone: {
                value: response.time_zone,
                name: response.time_zone
              }
            }
          })
          .catch(error => console.error(error))
      } catch (error) {
        console.error(error)
      }
    },
  };
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>
  /* MULTISELECT */
  .multiselect {
    min-height: 20px;
  }
  .multiselect__placeholder {
    margin-bottom: 0;
    padding-top: 0;
    padding-bottom: 2px;
  }
  .multiselect__tags {
    min-height: 20px;
    padding: 5px 40px 0 10px;
    margin-bottom: 0;
    border-color: #ced4da;
    border-radius: 0.25rem;
  }
  .invalid .multiselect__tags {
    border-color: #CE1938;
  }
  .multiselect__tag {
    padding: 2px 26px 2px 10px;
    margin-bottom: 0;
    color: #0479ff;
    background: #ecf4ff;
  }
  .multiselect__tag-icon:after {
    color: #0479ff;
  }
  .multiselect__option--highlight {
    color: #0479ff;
    background: #ecf4ff;
  }
  .multiselect__option--highlight::after{
    background: #0479ff;
  }
  .multiselect__tag-icon {
    line-height: 1.2rem;
  }
  .multiselect__tag-icon:hover {
    color: white;
    background: #0479ff;
  }
  .multiselect__select {
    height: 30px;
  }
  .multiselect__single {
    margin-bottom: 0;
    font-size: 1.2rem;
    line-height: 14px;
  }

  /*BUTTONS*/
  .btn-outline-primary {
    color: #303132;
    border-color: #303132;
    font-weight: bold;
  }
  .btn-outline-primary:hover:not(:disabled):not(.disabled),
  .btn-outline-primary.active:not(:disabled):not(.disabled) {
    color: #fff;
    background-color: #303132;
    border-color: #303132;
  }
</style>

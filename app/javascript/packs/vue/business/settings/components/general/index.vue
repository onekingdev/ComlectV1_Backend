<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-xl-5.py-xl-3.mb-0
            h3.mb-0 General
          .card-body.white-card-body.px-xl-5
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
                      :options="options.timeZone"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select Time Zone",
                      required)
                      .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone[0] }}
                  b-form-group#input-group-2(label='Country' label-for='select-2' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.country }"
                    )
                      multiselect#select-2(
                      v-model="form.country"
                      :options="options.country"
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
                      :options="options.state"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select State",
                      required)
                      .invalid-feedback.d-block(v-if="errors.state") {{ errors.state[0] }}
                  b-form-group#input-group-4(label='City' label-for='select-4' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.city }"
                    )
                      multiselect#select-4(
                      v-model="form.city"
                      :options="options.city"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select City",
                      required)
                      .invalid-feedback.d-block(v-if="errors.city") {{ errors.city[0] }}
                  b-form-group#input-group-8(label='Phone Number' label-for='input-8')
                    b-form-input#input-8(v-model='form.contact_phone' type='text' placeholder='Phone Number' required class="settings__card--label" :class="{'is-invalid': errors.contact_phone }")
                    .invalid-feedback.d-block(v-if="errors.contact_phone") {{ errors.contact_phone[0] }}
                  b-form-group.text-right
                    b-button.link.mr-2(type='reset' variant='none') Cancel
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
    components: {
      Multiselect,
      Loading,
    },
    data() {
      return {
        show: true,
        form: initialForm(),
        timeZoneOptions: [],
        options: {
          timeZone: [],
          country: [],
          state: [],
          city: [],
        },
        errors: {},
      };
    },
    methods: {
      onSubmit (event) {
        event.preventDefault()
        // clear errors
        this.errors = []

        const data = {
          "user": {
            "email": this.form.email,
            "password": this.form.password
          },
        }

        this.$store.dispatch('singIn', data)
          .then((response) => console.log(error))
          .catch((error) => console.error(error))
      },

      onChange (value) {
        if(value) {

        }
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
    mounted() {

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
    border-color: #cd1837;
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

  /* ALERTS*/
  .alert-primary {
    color: #303132;
    background-color: #ecf4ff;
    border-color: transparent;
    /*border-left-color: #0479ff;*/
    border-radius: 0;
    border-width: 0;
    box-shadow: inset 5px 0 0 #0479ff;
  }
  .alert-dismissible .close {
    top: 10px;
    font-size: 1.8rem;
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

  /*RADIO BUTTONS*/
  .custom-control-label{
    line-height: 2.1;
  }
  .custom-control-input:not(:disabled):active ~ .custom-control-label::before,
  .custom-control-input:checked ~ .custom-control-label::before {
    color: #fff;
    border-color: #303132;
    background-color: #303132;
  }
  .custom-control-label::before,
  .custom-control-label::after {
    left: -2rem;
    width: 1.5rem;
    height: 1.5rem;
  }
  .custom-radio .custom-control-input:checked ~ .custom-control-label::after {
    background-image: none;
    background-color: black;
    padding: 2px;
    border: solid 3px white;
    border-radius: 50%;
    box-shadow: 0 0 0px 2px black;
  }
</style>

<template lang="pug">
  div
    .row
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 General
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4 Location
            .row
              .col-md-6
                Loading
                b-form(v-if='!loading && show' @submit='onSubmit' @reset="onReset")
                  b-form-group#input-group-1(label='Time Zone' label-for='select-1' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.time_zone }"
                    )
                      multiselect#select-1(
                      v-model="form.time_zone"
                      :options="staticCollection.timezones"
                      :multiple="false"
                      :show-labels="false"
                      track-by="name",
                      label="name"
                      placeholder="Select Time Zone")
                      Errors(:errors="errors.time_zone")
                  b-form-group#input-group-2(label='Country' label-for='select-2' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.country }"
                    )
                      multiselect#select-2(
                      v-model="form.country"
                      :options="staticCollection.countries"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select Country")
                      Errors(:errors="errors.country")
                  b-form-group#input-group-3(label='State' label-for='select-3' label-class="settings__card--label required")
                    div(
                    :class="{ 'invalid': errors.state }"
                    )
                      multiselect#select-3(
                      v-model="form.state"
                      :options="staticCollection.states"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select State")
                      Errors(:errors="errors.state")
                  b-form-group#input-group-4(label='City' label-for='input-4' label-class="settings__card--label")
                    b-form-input#input-4(v-model='form.city' type='text' placeholder='City' :class="{'is-invalid': errors.city }")
                    Errors(:errors="errors.city")
                  b-form-group#input-group-5(label='Phone Number' label-for='input-5' label-class="settings__card--label")
                    b-form-input#input-5(v-model='form.contact_phone' type='text' placeholder='Phone Number' :class="{'is-invalid': errors.contact_phone }")
                    Errors(:errors="errors.contact_phone")
                  b-form-group.d-flex.justify-content-end.m-t-1
                    b-button.btn.btn-link.mr-2(type='reset') Cancel
                    b-button(type='submit' variant='dark') Save
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
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
        options: {
          timezones: [],
          countries: [],
          states: [],
        },
        errors: {},
      };
    },
    methods: {
      ...mapActions({
        general: 'settings/updateGeneralSettings',
        getCollection: 'settings/getStaticCollection'
      }),
      async onSubmit (event) {
        event.preventDefault()
        for (let value in this.errors) delete this.errors[value];
        try {
          this.form.time_zone = this.form.time_zone.value
          const response = await this.general(this.form)
          if (response) {
            if(response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
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
          }
          if (!response) console.error('error response', response)
        } catch (error) {
          console.error(error)
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
      ...mapGetters({
        loading: 'loading',
        staticCollection: 'settings/staticCollection',
      }),
    },
    async mounted () {
      try {
        const response = await this.general()
        if (response) {
          this.form = {
            ...response,
            time_zone: {
              value: response.time_zone,
              name: response.time_zone
            }
          }
        }
        if (!response) console.error('error general', response)

        const responseC = await this.getCollection()
        if (!responseC) console.error('error responseC', responseC)

      } catch (error) {
        console.error(error)
      }
    },
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

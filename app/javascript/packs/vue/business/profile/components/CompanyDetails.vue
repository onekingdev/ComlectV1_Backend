<template lang="pug">
  div
    Loading
    b-form(@submit='onSubmit' @reset='onReset' v-if='!loading && show')
      b-form-group#input-group-1
        h4.mb-3 Company Details
        .row
          .col
            .d-flex
              .preview.preview_sm
                b-img(v-if="url" left :src="url" alt="Preview image")
              .d-block
                b-form-file.mb-2(v-model="form.logo" :state="Boolean(form.logo)" ref="inputFile" accept="image/*" @change="onFileChange" plain)
                a.link(href='#' @click.prevent='onRemove') Remove
        .row
          .col-sm-6.pr-sm-2
            b-form-group#inputB-group-1(label='Company Name' label-for='inputB-1' label-class="label required")
              b-form-input#inputB-1(v-model='form.business.business_name' type='text' placeholder='Company Name' required :class="{'is-invalid': errors.business_name }")
              .invalid-feedback.d-block(v-if="errors.business_name") {{ errors.business_name[0] }}
          .col-sm-6.pl-sm-2
            b-form-group(label='CRD number' label-class="label")
              b-form-input(v-model="form.business.crd_number" type='text' placeholder="Enter your CRD number" :class="{'is-invalid': errors.crd_number }")
              .invalid-feedback.d-block(v-if="errors.crd_number") {{ errors.crd_number }}
        .row
          .col-sm.pr-sm-2
            b-form-group#inputB-group-2(label='AUM' label-for='inputB-2' label-class="label")
              b-form-input#inputB-2(v-model='form.business.aum' type='text' placeholder='AUM' required :class="{'is-invalid': errors.aum }")
              .invalid-feedback.d-block(v-if="errors.aum") {{ errors.aum[0] }}
          .col-sm.pl-sm-2
            b-form-group#inputB-group-3(label='Number of Accounts' label-for='label inputB-3' label-class="label")
              b-form-input#inputB-3(v-model='form.business.client_account_cnt' type='text' placeholder='Number of Accounts' required :class="{'is-invalid': errors.client_account_cnt }")
              .invalid-feedback.d-block(v-if="errors.client_account_cnt") {{ errors.client_account_cnt[0] }}
        .row
          .col-sm-6.pr-sm-2
            b-form-group#inputB-group-4(label='Industry' label-for='selectB-4' label-class="label required")
              div(
              :class="{ 'invalid': errors.industries }"
              )
                multiselect#selectB-4(
                v-model="form.business.industries"
                :options="industryOptions"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                placeholder="Select Industry",
                @input="onChange",
                required)
                .invalid-feedback.d-block(v-if="errors.industries") {{ errors.industries[0] }}
                // label.typo__label.form__label(v-if="errors.industries") {{ errors.industries[0] }}
          .col-sm-6.pl-sm-2
            b-form-group#inputB-group-5(label='Sub-Industry' label-for='selectB-5' label-class="label required")
              div(
              :class="{ 'invalid': errors.subIndustry }"
              )
                multiselect#selectB-5(
                v-model="form.business.sub_industries"
                :options="subIndustryOptions"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                placeholder="Select Sub-Industry",
                required)
                .invalid-feedback.d-block(v-if="errors.subIndustry") {{ errors.subIndustry[0] }}
        .row
          .col-sm-6.pr-sm-2
            b-form-group#inputB-group-6(label='Jurisdiction' label-for='selectB-6' label-class="label required")
              div(
              :class="{ 'invalid': errors.jurisdiction }"
              )
                multiselect#selectB-6(
                v-model="form.business.jurisdictions"
                :options="jurisdictionOptions"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                placeholder="Select Jurisdiction",
                required)
                .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction[0] }}
          .col-sm-6.pl-sm-2
            b-form-group#inputB-group-7(label='Time Zone' label-for='selectB-7' label-class="label required")
              div(
              :class="{ 'invalid': errors.time_zone }"
              )
                multiselect#selectB-7(
                v-model="form.business.time_zone"
                :options="timeZoneOptions"
                :multiple="false"
                :show-labels="false"
                track-by="name",
                label="name"
                placeholder="Select Time Zone",
                required)
                .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone[0] }}
        .row
          .col-sm-6.pr-sm-2
            b-form-group#inputB-group-8(label='Phone Number' label-for='inputB-8' label-class="label")
              b-form-input#inputB-8(v-model='form.business.contact_phone' type='text' placeholder='Phone Number' required :class="{'is-invalid': errors.contact_phone }")
              .invalid-feedback.d-block(v-if="errors.contact_phone") {{ errors.contact_phone[0] }}
          .col-sm-6.pl-sm-2
            b-form-group#inputB-group-7(label='Company Website' label-for='inputB-7' label-class="label" description="Optional")
              b-form-input#inputB-7.form-control(v-model='form.business.website' type='text' placeholder='Company Website' :class="{'is-invalid': errors.website }")
              .invalid-feedback.d-block(v-if="errors.website") {{ errors.website[0] }}
        hr
        .row
          .col-xl-9.pr-xl-2
            b-form-group#inputB-group-9(label='Business Address' label-for='inputB-9' label-class="label required")
              // b-form-input#inputB-9(v-model='form.business.address_1' placeholder='Business Address' required :class="{'is-invalid': errors.address_1 }" v-debounce:1000ms="onAdressChange")
              vue-google-autocomplete#map(ref="address" classname='form-control' :class="{'is-invalid': errors.address_1 }" v-model='form.business.address_1' placeholder='Business Address'  :fields="['address_components', 'adr_address', 'geometry', 'formatted_address', 'name']" v-on:placechanged='getAddressData')
              .invalid-feedback.d-block(v-if="errors.address_1") {{ errors.address_1[0] }}
          .col-xl-3.pl-xl-2
            b-form-group#inputB-group-10(label='Apt/Unit:' label-for='inputB-10' label-class="label")
              b-form-input#inputB-10(v-model='form.business.apartment' type='text' placeholder='Apt/Unit' required :class="{'is-invalid': errors.apartment }")
              .invalid-feedback.d-block(v-if="errors.apartment") {{ errors.apartment[0] }}
        .row
          .col-xl-4.pr-xl-2
            b-form-group#inputB-group-12(label='City' label-for='inputB-12' label-class="label required")
              b-form-input#inputB-12(v-model='form.business.city' type='text' placeholder='City' required :class="{'is-invalid': errors.city }")
              .invalid-feedback.d-block(v-if="errors.city") {{ errors.city[0] }}
          .col-xl-4.px-xl-2
            b-form-group#inputB-group-13(label='State' label-for='selectB-13' label-class="label required")
              div(
              :class="{ 'invalid': errors.state }"
              )
                multiselect#selectB-13(
                v-model="form.business.state"
                :options="stateOptions"
                :show-labels="false"
                placeholder="Select state",
                @input="onChangeState",
                required)
                .invalid-feedback.d-block(v-if="errors.state") {{ errors.state[0] }}
          .col-xl-4.pl-xl-2
            b-form-group#inputB-group-11(label='Zip' label-for='inputB-11' label-class="label required")
              b-form-input#inputB-11(v-model='form.business.zipcode' placeholder='Zip' required :class="{'is-invalid': errors.zipcode }")
              .invalid-feedback.d-block(v-if="errors.zipcode") {{ errors.zipcode[0] }}
        b-form-group.text-right
          b-button.btn.mr-2(type='reset') Cancel
          b-button.btn(type='submit' variant='primary') Save
</template>

<script>
  import VueGoogleAutocomplete from 'vue-google-autocomplete'
  import Multiselect from 'vue-multiselect'
  import Loading from '@/common/Loading/Loading'

  const initialForm = () => ({
    business: {
      crd_number: '',
      contact_phone: '',
      business_name: '',
      website: '',
      aum: '',
      apartment: '',
      client_account_cnt: '',
      address_1: '',
      city: '',
      state: '',
      zipcode: '',
      industries: [],
      sub_industries: [],
      jurisdictions: [],
      time_zone: [],
    }
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
        industryOptions: [],
        subIndustryOptions: [],
        jurisdictionOptions: [],
        stateOptions: [],
        timeZoneOptions: [],

        show: true,
        errors: {},
        url: null,
        inputFile: null
      }
    },
    methods: {
      onFileChange(e) {
        // Show preview
        const file = e.target.files[0];
        this.url = URL.createObjectURL(file);

        this.form.logo = this.$refs.inputFile.files[0];
      },
      onSubmit(event) {
        event.preventDefault()

        const params = {
          // 'logo': this.form.logo,
          'address': this.form.address,
          'phone': this.form.phone,
          'email': this.form.email,
          'disclosure': this.form.disclosure,
          'body': this.form.body,
        }
        // Add logo if it exist
        if (this.form.logo) params.logo = this.form.logo

        let formData = new FormData()

        Object.entries(params).forEach(
          ([key, value]) => formData.append(key, value)
        )
        // console.log('formData', formData)

        this.$store.dispatch('...', formData)
          .then(response => this.toast('Success', `Config successfully saved!`) )
          .catch(error => this.toast('Error', `Something wrong! ${error}`) )
      },
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
      onRemove() {
        this.url = null,
          this.form.logo = null
      },
      onChangeState(){
        delete this.errors.state
      },
      getAddressData (addressData, placeResultData, id) {
        // console.log('addressData', addressData)
        // console.log('placeResultData', placeResultData)
        // console.log('id', id)
        const input = document.getElementById(id)
        const { administrative_area_level_1, locality, postal_code } = addressData

        this.form.business.address_1 = input.value
        this.form.business.city = locality
        this.form.business.state = administrative_area_level_1
        this.form.business.zipcode = postal_code
      },
      onChange (industries) {
        if(industries) {
          delete this.errors.industries
          this.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.subIndustryIds) {
            for (const [key, value] of Object.entries(this.subIndustryIds)) {
              for (const i of results) {
                if (i === +key.split('_')[0]) {
                  this.subIndustryOptions.push({
                    value: key,
                    name: value
                  })
                }
              }
            }
          }
        }
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

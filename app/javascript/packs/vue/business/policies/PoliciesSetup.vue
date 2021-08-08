<template lang="pug">
  div.row
    .col-12
      Loading
    .col-12.col-lg-8
      b-form(@submit='onSubmit' @reset='onReset' v-if='!loading && show')
        b-form-group#input-group-1
          h4.heading-secondary.text-bold Logo
          p.paragraph Upload the logo that will show up on the cover page of your compolance manual (Logo visible&nbsp;
            br
            | on white recommend)
          .row
            .col-12.col-lg-3
              .preview
                b-img(v-if="url" left :src="url" alt="Preview image")
            .col-6
              b-form-file(v-model="form.logo"
              :state="Boolean(form.logo)"
              ref="inputFile"
              accept="image/*"
              placeholder="Choose a file or drop it here..."
              drop-placeholder="Drop file here..."
              @change="onFileChange")
              button.btn.link.m-t-10(@click='onRemove') Remove
        //b-form-group#input-groupAddress(label='Address:' label-for='inputAddress')
        //  b-form-input#inputAddress(v-model='form.address'  required)
        //b-form-group#input-groupPhone(label='Phone:' label-for='inputPhone')
        //  b-form-input#inputPhone(v-model='form.phone'  required)
        //b-form-group#input-groupEmail(label='Email:' label-for='inputEmail')
        //  b-form-input#inputEmail(v-model='form.email'  required)

        b-form-group(id="input-group-4" v-slot="{ ariaDescribedby }")
          h4.heading-secondary.text-bold Display Settings
          p.paragraph Select what you want to display on the cover page
          b-form-checkbox(v-model='form.address') Address
          b-form-checkbox(v-model='form.phone') Phone
          b-form-checkbox(v-model='form.email') Email
          b-form-checkbox(v-model='form.disclosure') Disclosure

        //b-form-group
        //  h4.heading-secondary Typography
        //  p Customize the text that shows up on your exported compilance manual
        //b-form-group#input-group-3(label='Font:' label-for='input-3')
        //  b-form-select#input-3(v-model='form.font' :options='fonts' required)
        //b-form-group
        //  .row
        //    .col
        //      b-form-group#input-group-4(label='Policy Name Typography:' label-for='input-3')
        //        b-form-select#input-4(v-model='form.font' :options='fonts' required)
        //    .col
        //      b-form-group#input-group-5(label='Section Typography:' label-for='input-3')
        //        b-form-select#input-5(v-model='form.font' :options='fonts' required)
        //  .row
        //    .col
        //      b-form-group#input-group-6(label='Subsection Typography:' label-for='input-3')
        //        b-form-select#input-6(v-model='form.font' :options='fonts' required)
        //    .col
        //      b-form-group#input-group-7(label='Paragraph Typography:' label-for='input-3')
        //        b-form-select#input-7(v-model='form.font' :options='fonts' required)
        //b-form-group(id="input-group-4" v-slot="{ ariaDescribedby }")
        //  h4.heading-secondary Display Settings
        //  p.paragraph Select what you want to display on the cover page
        //  b-form-checkbox-group#checkboxes-4(v-model='form.checked' :aria-describedby='ariaDescribedby')
        //    b-form-checkbox(value='address') Address
        //    b-form-checkbox(value='phoneNumber') Phone Number
        //    b-form-checkbox(value='contactEmail') Contact Email
        //    b-form-checkbox(value='disclosure') Disclosure
        b-form-group
          b-form-textarea(id="textarea"
                          v-model="form.body"
                          placeholder="Enter something..."
                          rows="3"
                          max-rows="6")
        b-form-group
          b-button.btn.mr-2(type='reset') Reset
          b-button.btn.btn-dark(type='submit' variant='primary') Save
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  // import axios from 'axios'
  export default {
    components: {
      Loading,
    },
    data() {
      return {
        form: {
          // email: '',
          // name: '',
          // font: null,
          // checked: [],

          logo: null,
          address: false,
          phone: false,
          email: false,
          disclosure: false,
          body: ''
        },
        // fonts: [{ text: 'Select One', value: null }, 'Times new Roman', 'Arial'],
        show: true,
        // text: '',
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

        this.$store.dispatch('postPolicyConfig', formData)
          .then(response => this.toast('Success', `Config successfully saved!`) )
          .catch(error => this.toast('Error', `Something wrong! ${error}`, true) )

        // axios.defaults.baseURL = '/api';
        // axios.defaults.headers.common['Authorization'] = 'TOKEN';
        // // axios.defaults.headers.post['Content-Type'] = 'application/json';
        // // Finally, sending the request with our beloved Axios
        // axios
        //   .patch('/business/compliance_policy_configuration', formData)
        //   .then(response => {
        //     console.log('axios response', response)
        //     this.toast('Success', `Config successfully saved!`)
        //   })
        //   .catch(error => {
        //     console.error('axios error', error)
        //     this.toast('Error', `Something wrong! ${error}`, true)
        //   })
        //   .finally(() => console.log('request finished'))
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.url = null,
        this.form.logo = null,
        this.form.address = false,
        this.form.phone = false,
        this.form.email = false,
        this.form.disclosure = false,
        this.form.body = ''
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      },
      onRemove() {
        this.url = null,
        this.form.logo = null
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    mounted() {
      this.$store
        .dispatch('getPolicyConfig')
        .then(response => {
          // console.log('response', response)
          // this.toast('Success', `Policy successfully deleted!`)

          // update form
          this.url = response.logo
          this.form = {
            // logo: response.logo,
            address: response.address,
            phone: response.phone,
            email: response.email,
            disclosure: response.disclosure,
            body: response.body,
          }

          // console.log('this.form after response', this.form)
        })
        .catch(error => {
          console.error(error)
          // this.toast('Error', `Couldn't submit form! ${error}`, true)
        })

      // fetch('/api/users/sign_in', {
      //   method: 'POST',
      //   headers: {
      //     // 'Authorization': 'Bearer test',
      //     'Accept': 'application/json',
      //     'Content-Type': 'application/json'},
      //   body: JSON.stringify({
      //     "user": {
      //       "email": "seriousbusiness@example.com",
      //       "password": "gtxtymrf",
      //     }
      //   })
      // }).then(response => {
      //   return response.json()
      // }).then(response => {
      //   if (response.errors) return response
      //   console.log('login', response)
      //   return response
      // }).catch (error => {
      //   throw error;
      // })
    }
  }
</script>

<style scoped>
  .preview {
    position: relative;
    z-index: 1;
    display: flex;
    justify-content: center;
    align-items: center;

    min-width: 125px;
    min-height: 125px;

    border: solid 1px #ced4da;
    border-radius: 3px;
  }

  /*.preview::after {*/
    /*display: block;*/
    /*position: absolute;*/
    /*z-index: 0;*/
    /*top: 60%;*/
    /*left: 80%;*/
    /*margin: auto;*/
    /*width: 100%;*/
    /*height: 100%;*/
    /*content: 'PREVIEW';*/
    /*color: #ced4da;*/
    /*text-transform: uppercase;*/
    /*font-size: 2rem;*/
    /*font-weight: bold;*/
    /*transform: translate(-50%, -50%) rotate(-45deg);*/
    /*transform-origin: center;*/
  /*}*/

  .preview img {
    position: relative;
    z-index: 2;
    max-width: 100%;
    max-height: 500px;
  }
</style>

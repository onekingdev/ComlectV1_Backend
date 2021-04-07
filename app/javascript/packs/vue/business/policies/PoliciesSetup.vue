<template lang="pug">
  div.row
    .col-12.col-lg-8
      Loading
      b-form(@submit='onSubmit' @reset='onReset' v-if='!loading && show')
        b-form-group#input-group-1
          h4 Logo
          p Upload the logo that will show up on the cover page of your compolance manual (Logo visible on white recommend)
          .row
            .col-12.col-lg-3
              .preview
                b-img(v-if="url" left :src="url" alt="Preview image")
            .col
              b-form-file(v-model="form.logo"
              :state="Boolean(form.logo)"
              placeholder="Choose a file or drop it here..."
              drop-placeholder="Drop file here..."
              @change="onFileChange")
              b-button Remove
        b-form-group#input-groupAddress(label='Address:' label-for='inputAddress')
          b-form-input#inputAddress(v-model='form.address'  required)
        b-form-group#input-groupPhone(label='Phone:' label-for='inputPhone')
          b-form-input#inputPhone(v-model='form.phone'  required)
        b-form-group#input-groupEmail(label='Email:' label-for='inputEmail')
          b-form-input#inputEmail(v-model='form.email'  required)

        b-form-group(id="input-group-4" v-slot="{ ariaDescribedby }")
          h4 Display Settings
          p Select what you want to display on the cover page
          b-form-checkbox(v-model='form.disclosure') Disclosure

        <!--b-form-group-->
          <!--h4 Typography-->
          <!--p Customize the text that shows up on your exported compilance manual-->
        <!--b-form-group#input-group-3(label='Font:' label-for='input-3')-->
          <!--b-form-select#input-3(v-model='form.font' :options='fonts' required)-->
        <!--b-form-group-->
          <!--.row-->
            <!--.col-->
              <!--b-form-group#input-group-4(label='Policy Name Typography:' label-for='input-3')-->
                <!--b-form-select#input-4(v-model='form.font' :options='fonts' required)-->
            <!--.col-->
              <!--b-form-group#input-group-5(label='Section Typography:' label-for='input-3')-->
                <!--b-form-select#input-5(v-model='form.font' :options='fonts' required)-->
          <!--.row-->
            <!--.col-->
              <!--b-form-group#input-group-6(label='Subsection Typography:' label-for='input-3')-->
                <!--b-form-select#input-6(v-model='form.font' :options='fonts' required)-->
            <!--.col-->
              <!--b-form-group#input-group-7(label='Paragraph Typography:' label-for='input-3')-->
                <!--b-form-select#input-7(v-model='form.font' :options='fonts' required)-->
        <!--b-form-group(id="input-group-4" v-slot="{ ariaDescribedby }")-->
          <!--h4 Display Settings-->
          <!--p Select what you want to display on the cover page-->
          <!--b-form-checkbox-group#checkboxes-4(v-model='form.checked' :aria-describedby='ariaDescribedby')-->
            <!--b-form-checkbox(value='address') Address-->
            <!--b-form-checkbox(value='phoneNumber') Phone Number-->
            <!--b-form-checkbox(value='contactEmail') Contact Email-->
            <!--b-form-checkbox(value='disclosure') Disclosure-->
        b-form-group
          b-form-textarea(id="textarea"
                          v-model="form.body"
                          placeholder="Enter something..."
                          rows="3"
                          max-rows="6")
        b-form-group
          b-button.btn.mr-2(type='reset') Reset
          b-button.btn.btn-dark(type='submit' variant='primary') Save
      b-card.mt-3(header='Form Data Result')
        pre.m-0 {{ form }}
</template>

<script>
  import Loading from '@/common/Loading/Loading'
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
          address: '',
          phone: '',
          email: '',
          disclosure: true,
          body: ''
        },
        // fonts: [{ text: 'Select One', value: null }, 'Times new Roman', 'Arial'],
        show: true,
        // text: '',
        url: null
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      onSubmit(event) {
        event.preventDefault()
        this.$store
          .dispatch('postPolicyConfig', this.form)
          .then(response => {
            console.log('response', response)
            this.makeToast('Success', `Policy Configsuccessfully sended!`)
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form.logo = null,
        this.form.address = '',
        this.form.phone = '',
        this.form.email = '',
        this.form.disclosure = true,
        this.form.body = ''
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      },
      onFileChange(e) {
        const file = e.target.files[0];
        this.url = URL.createObjectURL(file);
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
          console.log('response', response)
          // this.makeToast('Success', `Policy successfully deleted!`)

          // update form
          this.url = response.logo_data
          this.form = {
            // logo: response.logo_data,
            // address: response.address,
            // phone: response.phone,
            // email: response.email,
            // disclosure: trresponse.disclosure,
            // body: response.body,
          }

          console.log('this.form after response', this.form)
        })
        .catch(error => {
          console.error(error)
          // this.makeToast('Error', `Couldn't submit form! ${error}`)
        })
    }
  }
</script>

<style scoped>
  .preview {
    display: flex;
    justify-content: center;
    align-items: center;

    min-width: 125px;
    min-height: 125px;

    border: solid 1px #ced4da;
    border-radius: 3px;
  }

  .preview img {
    max-width: 100%;
    max-height: 500px;
  }
</style>

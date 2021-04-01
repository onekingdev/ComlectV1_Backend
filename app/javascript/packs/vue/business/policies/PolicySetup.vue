<template lang="pug">
  div.row
    .col-12.col-lg-8
      b-form(@submit='onSubmit' @reset='onReset' v-if='show')
        b-form-group#input-group-1
          h4 Logo
          p Upload the logo that will show up on the cover page of your compolance manual (Logo visible on white recommend)
          .row
            .col-12.col-lg-3
              b-img(left src="https://picsum.photos/125/125/?image=58" alt="Left image")
            .col
              b-form-file(v-model="file1"
              :state="Boolean(file1)"
              placeholder="Choose a file or drop it here..."
              drop-placeholder="Drop file here...")
              b-button Remove
        b-form-group
          h4 Typography
          p Customize the text that shows up on your exported compilance manual
        b-form-group#input-group-3(label='Font:' label-for='input-3')
          b-form-select#input-3(v-model='form.font' :options='fonts' required)
        b-form-group
          .row
            .col
              b-form-group#input-group-4(label='Policy Name Typography:' label-for='input-3')
                b-form-select#input-4(v-model='form.font' :options='fonts' required)
            .col
              b-form-group#input-group-5(label='Section Typography:' label-for='input-3')
                b-form-select#input-5(v-model='form.font' :options='fonts' required)
          .row
            .col
              b-form-group#input-group-6(label='Subsection Typography:' label-for='input-3')
                b-form-select#input-6(v-model='form.font' :options='fonts' required)
            .col
              b-form-group#input-group-7(label='Paragraph Typography:' label-for='input-3')
                b-form-select#input-7(v-model='form.font' :options='fonts' required)
        b-form-group(id="input-group-4" v-slot="{ ariaDescribedby }")
          h4 Display Settings
          p Select what you want to display on the cover page
          b-form-checkbox-group#checkboxes-4(v-model='form.checked' :aria-describedby='ariaDescribedby')
            b-form-checkbox(value='address') Address
            b-form-checkbox(value='phoneNumber') Phone Number
            b-form-checkbox(value='contactEmail') Contact Email
            b-form-checkbox(value='disclosure') Disclosure
        b-form-group
          b-form-textarea(id="textarea"
                          v-model="text"
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
  export default {
    data() {
      return {
        file1: null,
        form: {
          email: '',
          name: '',
          font: null,
          checked: []
        },
        fonts: [{ text: 'Select One', value: null }, 'Times new Roman', 'Arial'],
        show: true,
        text: ''
      }
    },
    methods: {
      onSubmit(event) {
        event.preventDefault()
        alert(JSON.stringify(this.form))
      },
      onReset(event) {
        event.preventDefault()
        // Reset our form values
        this.form.email = ''
        this.form.name = ''
        this.form.food = null
        this.form.checked = []
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      }
    }
  }
</script>

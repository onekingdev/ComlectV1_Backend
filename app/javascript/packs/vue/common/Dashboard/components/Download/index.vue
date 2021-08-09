<template lang="pug">
  div
    //b-dropdown.mr-2(variant="default")
    //  template(#button-content)
    //    | Monhly
    //    b-icon.ml-2(icon="chevron-down")
    //  b-dropdown-item Annually
    //  b-dropdown-item Monhly
    //  b-dropdown-item Weekly
    //  b-dropdown-item Daily
    b-dropdown#dropdown-form.m-0(ref='dropdown' variant="light-outline")
      template(#button-content)
        | Download
        //b-icon.ml-2(icon="chevron-down")
      b-dropdown-form.p-y-10(style="width: 400px;")
        b-row(no-gutters)
          .col-sm.m-r-1
            label.form-label Start Date
            DatePicker(v-model="download.start_date")
            Errors(:errors="errors.start_date")
          .col-sm
            label.form-label End Date
            DatePicker(v-model="download.end_date")
            Errors(:errors="errors.end_date")
        .d-flex.justify-content-between.m-y-20
          a.btn.link(:href="pdfUrl" target="_blank") Download All
          b-button(variant='secondary' size='sm' @click='onClick') Download
</template>

<script>
  export default {
    props: {
      pdfUrl: {
        type: String,
        required: true
      },
    },
    data() {
      return {
        download: {
          start_date: '',
          end_date: '',
        },
        errors: {}
      }
    },
    methods: {
      onClick() {
        // Close the menu and (by passing true) return focus to the toggle button
        this.$refs.dropdown.hide(true)
      },
    }
  }
</script>

<style scoped>

</style>

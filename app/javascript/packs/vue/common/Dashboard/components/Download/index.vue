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
    b-dropdown#dropdown-form.m-0(ref='dropdown' variant="default" @hide='handleHide($event)' @hidden='isCloseable=false' right)
      template(#button-content)
        b Download
        //b-icon.ml-2(icon="chevron-down")
      b-dropdown-form(style="width: 400px;" right)
        b-row.m-t-1(no-gutters)
          .col-sm.m-r-1
            label.form-label Start Date
            DatePicker(v-model="download.start_date")
            Errors(:errors="errors.start_date")
          .col-sm
            label.form-label End Date
            DatePicker(v-model="download.end_date")
            Errors(:errors="errors.end_date")
        .d-flex.justify-content-between.m-y-20
          a.btn.link(:href="pdfUrl" target="_blank" @click='closeMe') Download All
          a.btn.btn-secondary(:href="pdfRangeDownload" @click='closeMe') Download
</template>

<script>
  export default {
    props: {
      pdfUrl: {
        type: String,
        required: true
      },
      right: Boolean
    },
    data() {
      return {
        download: {
          start_date: '',
          end_date: '',
        },
        errors: {},
        isCloseable: false,
      }
    },
    methods: {
      handleHide(bvEvent) {
        // this.isCloseable = !this.isCloseable;
        if (!this.isCloseable) {
          bvEvent.preventDefault();
        } else {
          this.$refs.dropdown.hide();
        }
      },
      closeMe() {
        this.isCloseable = true;
        this.$refs.dropdown.hide();
      },
      close (e) {
        if (!this.$el.contains(e.target)) {
          this.isCloseable = false
        }
      }
    },
    computed: {
      pdfRangeDownload () {
        const start_date = this.download.start_date
        const end_date = this.download.end_date
        const url = `/reminders.csv?from_date=${start_date}&to_date=${end_date}`
        return url
      },
      datepickerOptions() {
        return {
          min: new Date().toISOString()
        }
      },
    },
    mounted () {
      document.addEventListener('click', this.close)
    },
    beforeDestroy () {
      document.removeEventListener('click',this.close)
    }
  }
</script>

<style scoped>

</style>

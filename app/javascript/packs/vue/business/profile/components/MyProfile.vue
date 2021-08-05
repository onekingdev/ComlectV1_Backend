<template lang="pug">
  div
    Loading
    b-form(@submit='onSubmit' @reset='onReset' v-if='!loading && show')
      b-form-group#input-group-1
        h4.mb-3 My profile
        .row
          .col
            .d-flex
              .preview.preview_sm
                b-img(v-if="url" left :src="url" alt="Preview image")
              .d-block
                b-form-file.mb-2(v-model="form.logo" :state="Boolean(form.logo)" ref="inputFile" accept="image/*" @change="onFileChange" plain)
                a.link(href='#' @click.prevent='onRemove') Remove
        .row
          .col.pr-2
            b-form-group#input-group-1(label='First Name:' label-for='input-1' label-class="label")
              b-form-input#input-1(v-model='form.first_name' type='text' placeholder='First Name' min="3" required)
              .invalid-feedback.d-block(v-if="errors.first_name") {{ errors.first_name[0] }}
          .col.pl-2
            b-form-group#input-group-2(label='Last Name:' label-for='input-2' label-class="label")
              b-form-input#input-2(v-model='form.last_name' type='text' placeholder='Last Name' min="3" required)
              .invalid-feedback.d-block(v-if="errors.last_name") {{ errors.last_name[0] }}
      b-form-group.text-right
        b-button.btn.btn-link.mr-2(type='reset') Cancel
        b-button.btn(type='submit' variant='primary') Save
</template>

<script>
  import Loading from '@/common/Loading/Loading'

  const initialForm = () => ({
    first_name: '',
    last_name: '',
    logo: null,
  })

  export default {
    name: "MyProfile",
    components: {
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
        this.form = initialForm2();
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

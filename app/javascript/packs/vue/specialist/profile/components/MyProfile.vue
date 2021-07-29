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
              .preview-switcher
                | Availability
                b-form-checkbox.ml-2(switch size="lg")
        .row
          .col.pr-2
            b-form-group#input-group-1(label='First Name:' label-for='input-1' label-class="label")
              b-form-input#input-1(v-model='form.first_name' type='text' placeholder='First Name' min="3" required)
              .invalid-feedback.d-block(v-if="errors.first_name") {{ errors.first_name[0] }}
          .col.pl-2
            b-form-group#input-group-2(label='Last Name:' label-for='input-2' label-class="label")
              b-form-input#input-2(v-model='form.last_name' type='text' placeholder='Last Name' min="3" required)
              .invalid-feedback.d-block(v-if="errors.last_name") {{ errors.last_name[0] }}
        b-form-group#input-group-3(label='Description:' label-for='input-3' label-class="label")
          b-form-textarea(id="textarea"
            v-model="form.description"
            placeholder="Description"
            rows="3"
            max-rows="6")
          .invalid-feedback.d-block(v-if="errors.description") {{ errors.description[0] }}
        .row
          .col-xl-6
            b-form-group#inputS-group-1(label='Jurisdiction' label-for='selectS-1' label-class="label required")
              div(
              :class="{ 'invalid': errors.jurisdiction }"
              )
                multiselect#selectS-1(
                v-model="form.jurisdiction"
                :options="form.jurisdictionOptions"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                placeholder="Select jurisdiction",
                required)
                .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction }}
          .col-xl-6
            b-form-group#inputS-group-4(label='Industry' label-for='selectS-4' label-class="label required")
              div(
              :class="{ 'invalid': errors.industry }"
              )
                multiselect#selectS-4(
                v-model="form.industry"
                :options="form.industryOptions"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                placeholder="Select Industry",
                @input="onChange",
                required)
                .invalid-feedback.d-block(v-if="errors.industry") {{ errors.industry }}
        .row
          .col-xl-6
            b-form-group(label='Where did you work?'  label-for='selectS-6' label-class="label pb-0" description="Optional")
              div(
              :class="{ 'invalid': errors.expertise }"
              )
                multiselect#selectS-6(
                v-model="form.expertise"
                :options="form.expertiseOptionsTags"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                tag-placeholder="Expertise",
                placeholder="Expertise",
                :taggable="true",
                @tag="addTag"
                required)
                .invalid-feedback.d-block(v-if="errors.regulator") {{ errors.regulator }}
          .col-xl-6
            b-form-group(label='Where did you work?'  label-for='selectS-7' label-class="label pb-0" description="Optional")
              div(
              :class="{ 'invalid': errors.regulator }"
              )
                multiselect#selectS-7(
                v-model="form.regulator"
                :options="form.regulatorOptionsTags"
                :multiple="true"
                :show-labels="false"
                track-by="name",
                label="name",
                tag-placeholder="Add this as new tag",
                placeholder="Search or add a tag",
                :taggable="true",
                @tag="addTag"
                required)
                .invalid-feedback.d-block(v-if="errors.regulator") {{ errors.regulator }}
        b-form-group.text-right
          b-button.btn.mr-2(type='reset') Cancel
          b-button.btn(type='submit' variant='primary') Save
        hr
        .row
          .col
            .d-flex.justify-content-between.align-items-center.m-y-20
              h4.mb-0 Skills
              ProfileAddEditSkills(:form="form" @compliteConfirmed="editSkills")
                button.btn.btn-default Edit Skills
        .row
          .col.m-b-20
            b-badge.mr-2(variant="default") skill1
            b-badge.mr-2(variant="default") skill2
        hr
        .row
          .col
            .d-flex.justify-content-between.align-items-center.m-y-20
              h4.mb-0 Experience
              ProfileAddEditExperience(:form="form" @compliteConfirmed="addExpirience")
                button.btn.btn-default Add Experience
        .row
          .col
            .card
              .card-body
                .row
                  .col
                    h3 Compliance Consultant
                    p Axe Capital | June 2019 - July 2020
                  .col
                    .d-flex.justify-content-end
                      b-button.btn.mr-2(type='button' variant='default') Remove
                      b-button.btn(type='button' variant='dark') Edit
                .row
                  .col
                    p Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate.

</template>

<script>
  import Multiselect from 'vue-multiselect'
  import Loading from '@/common/Loading/Loading'
  import ProfileAddEditSkills from "../modals/ProfileAddEditSkills";
  import ProfileAddEditExperience from "../modals/ProfileAddEditExperience";

  const initialForm = () => ({
    first_name: '',
    last_name: '',
    logo: null,
    description: '',
    jurisdiction: '',
    industry: '',
    expertise: '',
    regulator: '',
    skills: '',

    jurisdictionOptions: [],
    industryOptions: [],
    regulatorOptionsTags: [],
    expertiseOptionsTags: [],
    skillsTags: [],
  })

  export default {
    name: "MyProfile",
    components: {
      ProfileAddEditExperience,
      ProfileAddEditSkills,
      Loading,
      Multiselect,
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
      onChange (industries) {
        if(industries) {
          delete this.errors.industries
          this.form.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.subIndustryIds) {
            for (const [key, value] of Object.entries(this.subIndustryIds)) {
              for (const i of results) {
                if (i === +key.split('_')[0]) {
                  this.form.subIndustryOptions.push({
                    value: key,
                    name: value
                  })
                }
              }
            }
          }
        }
      },
      addTag (newTag) {
        const tag = {
          name: newTag,
          code: newTag.substring(0, 2) + Math.floor((Math.random() * 10000000))
        }
        this.form.expertiseOptionsTags.push(tag)
        this.form.expertise.push(tag)
      },
      editSkills () {
        console.log('editSkills complited')
      },
      addExpirience () {
        console.log('addExpirience complited')
      }
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

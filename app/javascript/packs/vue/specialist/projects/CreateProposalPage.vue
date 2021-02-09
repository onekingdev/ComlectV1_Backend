<template lang="pug">
  .container
    .card
      .card-body
        h2 Create Proposal
        .row
          .col-sm
            h3 Terms
            InputText(v-model="form.fixed_price" :errors="errors.fixed_price") Fixed Price
            h3 Pitch
            InputText(v-model="form.cover_letter" :errors="errors.cover_letter") Cover Letter
            InputText(v-model="form.additional_information" :errors="errors.additional_information") Additional Information
            h3 Attachments
            .card
              .card-body
                p
                  | Drop files here or
                  a.btn.btn-light Upload Files
            a.btn Cancel
            a.btn.btn-light Save Draft
            a.btn.btn-dark Submit Proposal
          .col-sm
            ProjectDetails(:project="project")
</template>

<script>
import ProjectDetails from './ProjectDetails'

const initialForm = () => ({
  fixed_price: null,
  or_hourl_price: null,
  cover_letter: null,
  additional_information: null
})

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      form: initialForm(),
      errors: {}
    }
  },
  components: {
    ProjectDetails
  }
}
</script>
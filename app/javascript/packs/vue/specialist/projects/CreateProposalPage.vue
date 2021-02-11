<template lang="pug">
  .container
    .card
      .card-body
        h2 Create Proposal
        .row
          .col-sm
            h3 Terms
            InputText(v-model="form.fixed_budget" :errors="errors.fixed_budget") Fixed Price
            hr
            h3 Pitch
            InputTextarea(v-model="form.message" :errors="errors.message" :rows="7") Cover Letter
            InputTextarea(v-model="form.additional_information" :errors="errors.additional_information") Additional Information
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
            Get(:project='`/api/specialist/projects/${projectId}`'): template(v-slot="{project}")
              ProjectDetails(:project="project")
</template>

<script>
import ProjectDetails from './ProjectDetails'

const endpointUrl = '/api/specialist/projects'

const initialForm = () => ({
  fixed_budget: null,
  hourly_rate: null,
  message: null,
  additional_information: null // @todo nonexistent field
})

export default {
  props: {
    projectId: {
      type: Number,
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
<template lang="pug">
  .d-inline-block
    button.btn.btn-dark(v-b-modal="'CompleteLocalProjectModal'") Complete Project
    b-modal#CompleteLocalProjectModal.fade(title="Complete Project" :hide-footer="!!hasSpecialist")
      div(v-if="hasSpecialist")
        p ⚠️
        p The project can't be completed because there is still a contract in progres. To continue, please end the contract with:
        p: strong {{ specialistName }}
      div(v-else)
        p ✅
        p The following project will be marked as complete.
        p: strong Do you want to continue?

      template(#modal-footer="{ hide }")
        button.btn(@click="hide") Cancel
        Post(
          :action="url"
          :model="{ status: 'complete' }"
          @saved="toast('Success', 'Project completed')"
          method="PUT"
        )
          button.btn.btn-default Confirm
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    url() {
      return '/api/business/local_project/' + this.project.id
    },
    hasSpecialist() {
      return this.project.projects[0] && this.project.projects[0].specialist_id && this.project.projects[0].specialist
    },
    specialistName() {
      return this.hasSpecialist && `${this.hasSpecialist.first_name} ${this.hasSpecialist.last_name}`
    }
  }
}
</script>
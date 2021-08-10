<template lang="pug">
  div
    button.dropdown-item(v-b-modal="'DeleteProjectModal'") Delete
    b-modal#DeleteProjectModal.fade(title="Delete Project")
      .row
        .col-md-1.text-center.px-0
          img.mt-1.ml-3(src='@/assets/error_20.svg' width="25" height="25")
        .col
          div(v-if="hasSpecialist")
            p.m-b-10 The project can't be deleted because there is still a contract in progres. To continue, please end the contract with:
            p.mb-0: strong {{ specialistName }}
          div(v-else)
            p The following project and all of its related tasks, documents, and activity will be deleted.
            p.mb-0: strong Do you want to continue?

      template(#modal-footer="{ hide }")
        button.btn.btn-link(@click="hide") Cancel
        Delete(v-if="!hasSpecialist" :url="deleteUrl" @deleted="deleted")
          button.btn.btn-dark Confirm
</template>

<script>
import { redirectWithToast } from '@/common/Toast'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  methods: {
    deleted() {
      this.$bvModal.hide('DeleteProjectModal')
      redirectWithToast(redirectUrl, 'Project deleted')
    }
  },
  computed: {
    hasSpecialist() {
      return this.project.projects[0] && this.project.projects[0].specialist_id && this.project.projects[0].specialist
    },
    specialistName() {
      return this.hasSpecialist && `${this.hasSpecialist.first_name} ${this.hasSpecialist.last_name}`
    },
    deleteUrl() {
      return `/api/business/local_projects/${this.project.id}`
    }
  }
}
</script>

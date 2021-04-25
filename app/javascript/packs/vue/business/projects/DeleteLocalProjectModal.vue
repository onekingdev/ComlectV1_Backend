<template lang="pug">
  div
    button.dropdown-item(v-b-modal="'DeleteProjectModal'") Delete Project
    b-modal#DeleteProjectModal.fade(title="Delete Project")
      div(v-if="hasSpecialist")
        p The project can't be deleted because there is still a contract in progres. To continue, please end the contract with:
        p: strong {{ specialistName }}
      div(v-else)
        p The following project and all of its related tasks, documents, and activity will be deleted.
        p: strong Do you want to continue?

      template(#modal-footer="{ hide }")
        button.btn(@click="hide") Cancel
        Delete(v-if="!hasSpecialist" :url="deleteUrl" @deleted="deleted")
          button.btn.btn-default Confirm
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
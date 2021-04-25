<template lang="pug">
  div
    button.dropdown-item(v-b-modal="'DeleteProjectModal'") Delete Project
    b-modal#DeleteProjectModal.fade(title="Delete Project")
      p The following project and all of its related tasks, documents, and activity will be deleted.
      p: strong Do you want to continue?

      template(#modal-footer="{ hide }")
        button.btn(@click="hide") Cancel
        Delete(:url="deleteUrl")
          button.btn.btn-default Confirm
</template>

<script>
export default {
  computed: {
    isDeleteAllowed() {
      return true
    },
    deleteUrl() {
      return ''
    }
  }
}
</script>
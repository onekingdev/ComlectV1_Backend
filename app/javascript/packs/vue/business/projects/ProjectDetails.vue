<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Project Details
      LocalProjectModal(@saved="$emit('saved')" :project-id="project.id")
        button.btn.btn-default Edit
    .card-body
      h3
      dl.row
        dt.col-sm-3 Title
        dd.col-sm-9 {{ project.title }}
        dt.col-sm-3 Start Date
        dd.col-sm-9 {{ project.starts_on | asDate }}
        dt.col-sm-3 Due Date
        dd.col-sm-9 {{ project.ends_on | asDate }}
        dt.col-sm-3 Details
        dd.col-sm-9 {{ project.description }}
        dt.col-sm-3 Members
        dd.col-sm-9
</template>

<script>
import LocalProjectModal from './LocalProjectModal'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  components: {
    LocalProjectModal
  }
}
</script>

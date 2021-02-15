<template lang="pug">
  div
    Breadcrumbs(:items="['Projects', project.title]")
    h2 {{ project.title }}
    h3 {{ currentBusiness }}
    b-tabs(content-class="mt-0")
      b-tab(title="Overview" active)
        .card-body.white-card-body
          ApplicationsNotice(:project="project")
          ProjectDetails(:project="project")
      b-tab(title="Tasks")
        .card-body.white-card-body
      b-tab(title="Documents")
        .card-body.white-card-body
      b-tab(title="Collaborators")
        .card-body.white-card-body
      b-tab(title="Activity")
        .card-body.white-card-body
</template>

<script>
import ApplicationsNotice from './ApplicationsNotice'
import ProjectDetails from './ProjectDetails'

export default {
  props: {
    currentBusiness: {
      type: String,
      required: true
    },
    project: {
      type: Object,
      required: true
    }
  },
  components: {
    ApplicationsNotice,
    ProjectDetails
  }
}
</script>
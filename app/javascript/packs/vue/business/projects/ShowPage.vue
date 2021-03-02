<template lang="pug">
  div
    Breadcrumbs(:items="['Projects', project.title]")
    h2 {{ project.title }}
    h3 {{ currentBusiness }}
    b-tabs(content-class="mt-0")
      b-tab(title="Overview" active)
        .card-body.white-card-body
          ApplicationsNotice(:project="project.visible_project")
          Get(:project="`/api/business/projects/${project.visible_project.id}`"): template(v-slot="{project}")
            TimesheetsNotice(:project="project")
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
import TimesheetsNotice from './TimesheetsNotice'
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
    TimesheetsNotice,
    ProjectDetails
  }
}
</script>
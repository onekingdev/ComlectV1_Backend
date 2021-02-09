<template lang="pug">
  .p-3
    h3 {{ project.title }}
    dl.row
      dt.col-sm-3 Location
      dd.col-sm-9
      dt.col-sm-3 Industry
      dd.col-sm-9
      dt.col-sm-3 Start Date
      dd.col-sm-9 {{ project.starts_on | asDate }}
      dt.col-sm-3 End Date
      dd.col-sm-9 {{ project.ends_on | asDate }}
      dt.col-sm-3 Key Deliverables
      dd.col-sm-9 {{ project.key_deliverables }}
    p {{ project.description }}
    ProjectFigures(:project="project")
    hr
    h2 Skills
    hr
    h2 Client Details
</template>

<script>
import ProjectFigures from './ProjectFigures'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  components: {
    ProjectFigures
  }
}
</script>
<template lang="pug">
  .p-3
    h3 {{ project.title }}
    dl.row
      dt.col-sm-3 Location
      dd.col-sm-9 {{ project.location }}
      dt.col-sm-3 Industry
      dd.col-sm-9 {{ project.industries | names }}
      dt.col-sm-3 Start Date
      dd.col-sm-9 {{ project.starts_on | asDate }}
      dt.col-sm-3 End Date
      dd.col-sm-9 {{ project.ends_on | asDate }}
      dt.col-sm-3 Min. Experience
      dd.col-sm-9 {{ project.minimum_experience }}
      dt.col-sm-3 Description
      dd.col-sm-9 {{ project.description }}
    p {{ project.role_details }}
    ProjectFigures(:project="project")
    hr
    h2 Skills
    p {{ project.skills | names }}
    hr
    h2 Client Details
    ClientDetails(:business="project.business")
</template>

<script>
import ClientDetails from './ClientDetails'
import ProjectFigures from './ProjectFigures'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  components: {
    ClientDetails,
    ProjectFigures
  }
}
</script>
<template lang="pug">
  div
    b-card(v-for="project in projects" :title="project.title" :sub-title="project.subTitle" :key="project.id")
      b-card-text {{project.description}}
      b-button(href="#" variant="primary") View Details
</template>

<script>
const endpointUrl = '/api/specialist/projects'

const parse = p => ({
  ...p,
  id: p.id + (p.starts_on ? '-p' : '-lp'),
  subTitle: `${p.location_type}`
})

export default {
  data() {
    return {
      projects: []
    }
  },
  created() {
    this.refetch()
  },
  methods: {
    refetch() {
      fetch(endpointUrl, { headers: {'Accept': 'application/json'}})
        .then(response => response.json())
        .then(result => this.projects = result.map(parse))
    }
  }
}
</script>
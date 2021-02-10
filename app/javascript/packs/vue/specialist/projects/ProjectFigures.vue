<template lang="pug">
  ul.list-group.list-group-horizontal
    li.list-group-item(v-if="project.pricing_type === 'fixed'")
      | Fixed Budget
      br
      | {{ (project.est_budget || project.fixed_budget) | usdWhole }}
    li.list-group-item(v-else)
      | Hourly
      br
      | $ {{ project.hourly_rate | usdWhole }}
    li.list-group-item
      | Experience
      br
      | {{ project.minimum_experience }}
    li.list-group-item
      | Jurisdiction
      br
      | {{ project.jurisdictions | names }}
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  }
}
</script>
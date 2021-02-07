<template lang="pug">
  .row
    .col-sm-3
      b-card.m-2(title="Filters")
        h5.d-flex.justify-content-between(role="button" v-b-toggle.collapse_pricing_type)
          | Job Type
          ion-icon(name='chevron-down-outline')
        b-collapse#collapse_pricing_type(visible)
          b-form-checkbox(v-for="(option, i) in pricingTypeOptions" v-model="filter.pricing_type[i]") {{option.label}}
        hr
        h5.d-flex.justify-content-between(role="button" v-b-toggle.collapse_experience)
          | Experience Level
          ion-icon(name='chevron-down-outline')
        b-collapse#collapse_experience(visible)
          b-form-checkbox(v-for="(option, i) in experienceOptions" v-model="filter.experience[i]") {{option.label}}
        hr
        h5.d-flex.justify-content-between(@click="refetch" role="button" v-b-toggle.collapse_budget)
          | Budget
          ion-icon(name='chevron-down-outline')
        b-collapse#collapse_budget(visible)
          b-form-checkbox(v-for="(option, i) in budgetOptions" v-model="filter.budget[i]") {{option.label}}
        hr
        h5.d-flex.justify-content-between(role="button" v-b-toggle.collapse_duration)
          | Estimated Duration
          ion-icon(name='chevron-down-outline')
        b-collapse#collapse_duration(visible)
          b-form-checkbox(v-for="(option, i) in durationOptions" v-model="filter.duration[i]") {{option.label}}

    .col-sm-9
      b-card.m-2
        h3 Browse Projects
      b-card.m-2(v-for="project in projects" :title="project.title" :sub-title="project.subTitle" :key="project.id")
        b-card-text {{project.description}}

        ul.list-group.list-group-horizontal
          li.list-group-item(v-if="project.pricing_type === 'fixed'")
            | Fixed Budget
            br
            | $ {{ project.est_budget || project.fixed_budget }}
          li.list-group-item(v-else)
            | Hourly
            br
            | $ {{ project.hourly_rate }}
          li.list-group-item
            | Experience
            br
            | {{ project.minimum_experience }}
          li.list-group-item
            | Jurisdiction
            br
            | -

        b-button(href="#" variant="primary" style="float: right") View Details
</template>

<script>
const endpointUrl = '/api/specialist/projects'

const parse = p => ({
  ...p,
  id: p.id + (p.starts_on ? '-p' : '-lp'),
  subTitle: `${p.location_type}`
})

const PRICING_TYPE_OPTIONS = [{ label: 'Fixed Price', value: 'fixed' }, { label: 'Hourly', value: 'hourly' }]
const EXPERIENCE_OPTIONS = [{ label: 'Junior', value: [0, 3] },{ label: 'Intermediate', value: [4, 6] },{ label: 'Expert', value: [7, 9] }]
const BUDGET_OPTIONS = [{ label: 'Less than $100', value: [0, 100] },
                        { label: '$100 - $250', value: [100, 250] },
                        { label: '$250 - $500', value: [250, 500] },
                        { label: '$500 - $1000', value: [500, 1000] },
                        { label: '$1k - $5k', value: [1000, 5000] },
                        { label: '$5k+', value: [5000, 99999999] }]
const DURATION_OPTIONS = [{ label: 'Less than 1 month', value: '' },
                          { label: '1 to 3 months', value: '' },
                          { label: '3 to 6 months', value: '' },
                          { label: 'More than 6 months', value: '' }]

const initialFilter = () => ({
  pricing_type: PRICING_TYPE_OPTIONS.map(() => false),
  experience: EXPERIENCE_OPTIONS.map(() => false),
  budget: BUDGET_OPTIONS.map(() => false),
  duration: DURATION_OPTIONS.map(() => false)
})

export default {
  data() {
    return {
      projects: [],
      filter: initialFilter()
    }
  },
  methods: {
    refetch() {
      fetch(endpointUrl + this.filterQuery, { headers: {'Accept': 'application/json'}})
        .then(response => response.json())
        .then(result => this.projects = result.map(parse))
    }
  },
  computed: {
    pricingTypeOptions: () => PRICING_TYPE_OPTIONS,
    experienceOptions: () => EXPERIENCE_OPTIONS,
    budgetOptions: () => BUDGET_OPTIONS,
    durationOptions: () => DURATION_OPTIONS,
    filterQuery() {
      let query = []
      const flattenRanges = param => (result, option, i) => this.filter[param][i] ? [...result, option.value[0], option.value[1]] : result
      const budget = this.budgetOptions.reduce(flattenRanges('budget'), [])
      if (budget.length) {
        query.push('project_value=' + Math.min(...budget) + '%3B' + Math.max(...budget))
      }
      const experience = this.experienceOptions.reduce(flattenRanges('experience'), [])
      if (experience.length) {
        query.push('experience=' + Math.min(...experience) + '%3B' + Math.max(...experience))
      }
      return '?' + query.join('&')
    }
  },
  watch: {
    'filter': {
      deep: true,
      immediate: true,
      handler(val, oldVal) {
        this.refetch()
      }
    }
  }
}
</script>
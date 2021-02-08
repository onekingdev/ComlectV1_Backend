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
      b-card.m-2
        .row
          .col-sm
            b-form-group.mb-0(label="Search" label-for="search-input")
              b-form-input#search-input(v-model="search" placeholder="Enter project type, keywords, etc.")
          .col-sm
            b-form-group.mb-0(label="Sort By" label-for="sort-input")
              b-form-select#sort-input(value="Newest" :options="['Newest']")
      b-card.m-2(v-for="project in projects" :title="project.title" :key="project.uid")
        h6.card-subtitle.text-muted.mb-2 {{project.subTitle}} | Start {{project.starts_on|asDate}}

        b-card-text {{project.description}}

        ProjectFigures(:project="project")

        b-button(@click="openProjectDetails(project.id)" variant="primary" style="float: right") View Details

    b-sidebar#ProjectSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop right width="60%")
      ProjectDetails(v-if="project" :project="project")
      b-button.m-3(@click="isSidebarOpen = false") Close
</template>

<script>
import ProjectFigures from './ProjectFigures'
import ProjectDetails from './ProjectDetails'

const frontendUrl = '/projects'
const endpointUrl = '/api/specialist/projects'

const parse = p => ({
  ...p,
  uid: p.id + (p.starts_on ? '-p' : '-lp'),
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
  props: {
    initialOpenId: {
      type: Number
    }
  },
  data() {
    return {
      projects: [],
      project: null,
      filter: initialFilter(),
      openId: null,
      isSidebarOpen: false,
      search: null
    }
  },
  created() {
    if (this.initialOpenId) {
      this.openProjectDetails(this.initialOpenId)
    }
  },
  methods: {
    refetch() {
      fetch(endpointUrl + this.filterQuery, { headers: {'Accept': 'application/json'}})
        .then(response => response.json())
        .then(result => this.projects = result.map(parse))
    },
    openProjectDetails(id) {
      this.openId = id
      history.pushState({}, '', `${frontendUrl}/${id}`)
      fetch(endpointUrl + '/' + this.openId, { headers: {'Accept': 'application/json'}})
        .then(response => response.json())
        .then(result => {
          this.project = result
          this.isSidebarOpen = true
        })
    },
    closeSidebar() {
      this.openId = null
      this.project = null
      history.pushState({}, '', frontendUrl)
      this.isSidebarOpen = false
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
    },
    'isSidebarOpen': {
      immediate: true,
      handler(val, oldVal) {
        document.body.classList[val ? 'add' : 'remove']('overflow-y-hidden')
      }
    }
  },
  components: {
    ProjectFigures,
    ProjectDetails
  }
}
</script>

<style>
.overflow-y-hidden {
  overflow-y: hidden !important;
}
</style>
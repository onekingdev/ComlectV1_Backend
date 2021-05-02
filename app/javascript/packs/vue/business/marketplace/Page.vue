<template lang="pug">
  div.marketplace
    .container-fluid
      .row
        .col-12.px-0.mb-4
          div.marketplace__head.marketplace__head_bg
            h2.marketplace__title {{ pageTitle }}
            p.marketplace__subtitle Find the right consultant for the right job
    .container
      .row
        .col-lg-3
          .card#sidebarMenu_alt
            .card-header(style='border-bottom: 0px;')
              b Filters
            .card-body
              h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_industry)
                | Industry
                ion-icon(name='chevron-down-outline')
              b-collapse#collapse_industry(visible)
                b-form-input(v-model="filter.industry")
              hr
              h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_experience)
                | Experience Level
                ion-icon(name='chevron-down-outline')
              b-collapse#collapse_experience(visible)
                b-form-checkbox(v-for="(option, i) in experienceOptions" v-model="filter.experience[i]" :key="'e'+i") {{option.label}}
              hr
              h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_hourly_rate)
                | Hourly rate
                ion-icon(name='chevron-down-outline')
              b-collapse#collapse_hourly_rate(visible)
                <!--b-form-checkbox(v-for="(option, i) in pricingTypeOptions" v-model="filter.pricing_type[i]" :key="'hr'+i") {{option.label}}-->
                vue-range-slider.mb-5(
                ref='slider' v-model='value'
                :min="min" :max="max" :formatter="formatter" :tooltip-merge="tooltipMerge" :enable-cross="enableCross"
                :bgStyle="bgStyle" :tooltipStyle="tooltipStyle" :processStyle="processStyle" :slider-style="sliderStyle"
                :tooltip-dir='tooltipDir')
              hr
              h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_jurisdiction)
                | Jurisdiction
                ion-icon(name='chevron-down-outline')
              b-collapse#collapse_jurisdiction(visible)
                b-form-input(v-model="filter.jurisdiction")
              hr
              h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_fromer_regulator)
                | Fromer Regulator
                ion-icon(name='chevron-down-outline')
              b-collapse#collapse_fromer_regulator(visible)
                b-form-checkbox(v-for="(option, i) in fromer_regulatorOptions" v-model="filter.fromer_regulator[i]" :key="'fr'+i") {{option.label}}

        .col-lg-9
          .card
            .card-header
              .col-md-12
                h3 Browse Specialist
            .card-header
              .col-md-12
                .row.py-2
                  .col-sm-12
                    b-form-group(label="Search" label-for="search-input")
                      b-form-input#search-input(v-model="search" placeholder="Enter keywords, skills, etc.")
                .row.py-2
                  .col
                    b-badge(variant="light")
                      | Mock audit
                      ion-icon.ml-2(name='close-outline')

            .card-header(v-if="loading")
              .row.py-2.px-4
                .col
                  Loading
            SpecialistPanel(v-for="specialist in specialistsList" :specialist="specialist" :key="specialist.id")
            .card-body.m-2.text-danger(v-if="!specialistsList.length"  title="No specialists")

      b-sidebar#ProjectSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop right width="60%")
        .card
          .card-header.borderless
            .d-flex.justify-content-between
              b-button(variant="default" @click="isSidebarOpen = false") < Close
              div
                a.btn.btn-default(href="#") Save
                a.btn.btn-default.m-l-1(href="#") Share
            .d-flex.justify-content-between.m-t-1
              h4 Project Details
              div
                a.btn.btn-dark(v-if="project" :href="applyUrl(project)") Apply
          SpecialistDetails(v-if="project" :project="project")
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import SpecialistPanel from './SpecialistPanel'
  import SpecialistDetails from './SpecialistDetails'

  // import 'vue-range-component/dist/vue-range-slider.css'
  // import VueRangeSlider from 'vue-range-component'


  const frontendUrl = '/projects'
  const endpointUrl = '/api/specialist/projects'

  const parse = p => ({
    ...p,
    uid: p.id + (p.starts_on ? '-p' : '-lp'),
    subTitle: [p.location_type, ...p.industries.map(({ name }) => name)].join(' | ')
  })

  const PRICING_TYPE_OPTIONS = [{ label: 'Fixed Price', value: 'fixed' }, { label: 'Hourly', value: 'hourly' }]
  const EXPERIENCE_OPTIONS = [{ label: 'Junior', value: [0, 0] },{ label: 'Intermediate', value: [1, 1] },{ label: 'Expert', value: [2, 2] }]
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
  const FORMER_REGULATOR_OPTIONS = [{ label: 'SEC', value: '' },
    { label: 'FINRA', value: '' },
    { label: 'State', value: '' },
    { label: 'Internationsl', value: '' }]

  const initialFilter = () => ({
    pricing_type: PRICING_TYPE_OPTIONS.map(() => false),
    experience: EXPERIENCE_OPTIONS.map(() => false),
    budget: BUDGET_OPTIONS.map(() => false),
    duration: DURATION_OPTIONS.map(() => false),
    fromer_regulator: FORMER_REGULATOR_OPTIONS.map(() => false),
    industry: '',
    jurisdiction: ''
  })

  export default {
    components: {
      Loading,
      // VueRangeSlider,
      SpecialistPanel
    },
    data() {
      return {
        pageTitle: "Specialist Marketplace",
        projects: [],
        project: null,
        filter: initialFilter(),
        openId: null,
        isSidebarOpen: false,
        search: null,
        value: [0, 100]
      };
    },
    created() {
      if (this.initialOpenId) {
        this.openDetails(this.initialOpenId)
      }

      this.min = 0
      this.max = 250
      this.bgStyle = {
        backgroundColor: '#fff',
        boxShadow: 'inset 0.5px 0.5px 3px 1px rgba(0,0,0,.36)'
      }
      this.tooltipStyle = {
        // color: '#303132',
        backgroundColor: '#303132',
        borderColor: '#303132'
      }
      this.processStyle = {
        backgroundColor: '#303132'
      },
      this.sliderStyle = {
        backgroundColor: '#303132',
      },
      this.enableCross = false,
      this.tooltipMerge = false,
      this.formatter = value => `$${value}`,
      this.tooltipDir = 'bottom'
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      refetch() {
        fetch(endpointUrl + this.filterQuery, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => this.projects = result.map(parse))
      },
      openDetails(id) {
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
      },
      applyUrl(project) {
        return `/projects/${project.id}/applications/new`
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      pricingTypeOptions: () => PRICING_TYPE_OPTIONS,
      experienceOptions: () => EXPERIENCE_OPTIONS,
      budgetOptions: () => BUDGET_OPTIONS,
      durationOptions: () => DURATION_OPTIONS,
      fromer_regulatorOptions: () => FORMER_REGULATOR_OPTIONS,
      filterQuery() {
        let query = []

        const getCheckedItems = (options, property) => options.reduce((result, option, i) => this.filter[property][i] ? [...result, option] : result, [])
        const buildParam = param => ({ value }) => `${param}[]=${value[0]},${value[1]}`

        const pricingTypes = getCheckedItems(this.pricingTypeOptions, 'pricing_type')
        query.push(pricingTypes.length === 1 ? `pricing_type=${pricingTypes[0].value}` : '')

        getCheckedItems(this.experienceOptions, 'experience').map(buildParam('experience')).map(arg => query.push(arg))
        getCheckedItems(this.budgetOptions, 'budget').map(buildParam('budget')).map(arg => query.push(arg))

        return query.length ? ('?' + query.join('&')) : ''
      },
      specialistsList() {
        return this.$store.getters.specialistsList;
      }
    },
    mounted() {
      this.$store
        .dispatch("getSpecialists")
        .then((response) => {
          console.log('response: ', response);
        })
        .catch((err) => {
          console.error(err);
          this.makeToast('Error', err.message)
        });
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

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

            .card-header(v-if="!loading && specialistsList" v-for="specialist in specialistsList" :key="specialist.id")
              .row.py-2.px-4
                .col-lg-2.col-3
                  b-img(v-bind="mainProps" rounded="circle" alt="image_desc" :src="specialist.photo ? specialist.photo : `https://loremflickr.com/100/100/cat?lock=${specialist.id}`")
                .col-lg-10.col-9
                  .row
                    .col-md-9.col
                      h3.m-b-1
                        a.link(:href="specialist.resume_url" @click="openDetails(project.id)" target="_blank") {{ specialist.first_name }} {{ specialist.last_name }}
                      h6.pb-1.card-subtitle.text-muted.mb-2  {{ specialist.location }} |
                        .d-inline(v-if="specialist.industries" v-for="ind in specialist.industries") &nbsp;{{ ind.name }}&nbsp;
                      .d-flex.py-2
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star' variant="warning" font-scale="1.5")
                      .d-flex.py-2
                        .badge.badge-default.m-r-1 Auditing
                        .badge.badge-default.m-r-1 Compilance Reporting
                        .badge.badge-default.m-r-1 Mock Interviews
                    .col-md-3.col.justify-content-end
                      .d-flex.align-items-center.justify-content-lg-end
                        b-icon.linkedin.mr-3(icon='linkedin' font-scale="1.5")
                        b-button(variant="default") Message
                .offset-lg-2.col-lg-10.col
                  b-card-text.m-t-1
                    | Hi, my name Chris Jakson Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
                    | laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
                  .d-flex.justify-content-between
                    ul.list-group.list-group-horizontal.w-100.project-figures.specialist-figures
                      li.list-group-item
                        ion-icon.float-left.mt-3.mr-3(name="cash-outline")
                        | Hourly rate
                        br
                        b ${{ specialist.min_hourly_rate ? specialist.min_hourly_rate : 0 }}
                      li.list-group-item
                        ion-icon.float-left.mt-3.mr-3(name="analytics-outline")
                        | Expirience
                        br
                        b {{ specialist.experience }}
                      li.list-group-item
                        ion-icon.float-left.mt-3.mr-3(name="earth-outline")
                        | Jurisdiction
                        br
                        b(v-if="specialist.jurisdictions" v-for="jur in specialist.jurisdictions") &nbsp;{{ jur.name }}&nbsp;
            .card-body.m-2.text-danger(title="No specialists")

            .card-header(v-for="project in projects" :key="project.uid")
              .col-md-12
                h3.m-b-1
                  a(@click="openDetails(project.id)") {{project.title}}
                h6.pb-1.card-subtitle.text-muted.mb-2 {{project.subTitle}} | Start {{project.starts_on|asDate}}
                .badge.badge-default.m-r-1(v-for="skill in project.skills") {{ skill.name }}
                b-card-text.m-t-1 {{project.description}}
                .d-flex.justify-content-between
                  SpecialistFigures(:project="project")
                  div.m-t-1
                    b-button(@click="openDetails(project.id)" variant="default") View Details
            .card-body.m-2.text-danger(v-if="!projects.length" title="No projects")

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
  import SpecialistFigures from './SpecialistFigures'
  import SpecialistDetails from './SpecialistDetails'

  import 'vue-range-component/dist/vue-range-slider.css'
  import VueRangeSlider from 'vue-range-component'


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
      VueRangeSlider
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
        value: [0, 100],
        mainProps: { blank: false, blankColor: '#777', width: 100, height: 100, class: 'm1' }
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
          console.log(response);
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

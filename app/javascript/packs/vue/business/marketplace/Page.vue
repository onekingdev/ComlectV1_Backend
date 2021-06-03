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
          MarketPlaceFilter(:optionsForRequest="optionsForRequest" :filter="filter")

        .col-lg-9
          .card
            .card-header
              .col-md-12
                h3 Browse Specialist
            .card-header
              MarketPlaceSearchInput

            .card-header(v-if="loading")
              .row.py-2.px-4
                .col
                  Loading
            SpecialistPanel(v-for="specialist in specialists" :specialist="specialist" :key="specialist.id" @directMessage="isSidebarOpen = true")
            .card-body.m-2.text-danger(v-if="!specialists && !specialists.length"  title="No specialists")

      b-sidebar#ProjectSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop right width="60%")
        .card
          .card-header.borderless
            .d-flex.justify-content-between
              b-button(variant="default" @click="isSidebarOpen = false") < Close
              div
                a.btn.btn-default(href="#") Send
                // a.btn.btn-default.m-l-1(href="#") Share
            .d-flex.justify-content-between.m-t-1
              h4 Messages Details
              div
                a.btn.btn-dark(v-if="project" :href="applyUrl(project)") Apply
          SpecialistDetails(v-if="project" :project="project")
</template>

<script>
  import { mapGetters } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import MarketPlaceFilter from './components/MarketPlaceFilter'
  import MarketPlaceSearchInput from './components/MarketPlaceSearchInput'
  import SpecialistPanel from './components/SpecialistPanel'
  import SpecialistDetails from './components/SpecialistDetails'
  import _debounce from 'lodash/debounce'

  // import 'vue-range-component/dist/vue-range-slider.css'

  const frontendUrl = '/projects'
  const endpointUrl = '/api/specialist/projects'

  const parse = p => ({
    ...p,
    uid: p.id + (p.starts_on ? '-p' : '-lp'),
    subTitle: [p.location_type, ...p.industries.map(({ name }) => name)].join(' | ')
  })

  const PRICING_TYPE_OPTIONS = [{ label: 'Fixed Price', value: 'fixed' }, { label: 'Hourly', value: 'hourly' }]
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
    budget: BUDGET_OPTIONS.map(() => false),
    duration: DURATION_OPTIONS.map(() => false),
    fromer_regulator: FORMER_REGULATOR_OPTIONS.map(() => false),
    industry: '',
    jurisdiction: ''
  })

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states'],
    components: {
      Loading,
      // VueRangeSlider,
      SpecialistPanel,
      MarketPlaceFilter,
      MarketPlaceSearchInput
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
        optionsForRequest: {
          industries: '',
          experienceLevel: [],
          hourlyRate: [10, 500],
          jurisdictions: '',
          formerRegulator: []
        }
      };
    },
    created() {
      this.debouncedSend = _debounce(this.sendRequest, 2000)
      if (this.initialOpenId) {
        this.openDetails(this.initialOpenId)
      }

      if(this.industryIds) this.filter.industryOptions = this.industryIds
      if(this.jurisdictionIds) this.filter.jurisdictionOptions = this.jurisdictionIds
    },
    unmounted() {
      this.debouncedSend.cancel()
    },
    watch: {
      optionsForRequest: {
        handler: function (newValue, oldValue) {
          this.debouncedSend(newValue, oldValue)
        },
        deep: true
      }
    },
    methods: {
      sendRequest(newValue, oldValue) {
        console.log('changed: ', newValue)
      },
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
      ...mapGetters({
        specialists: 'marketplace/specialists'
      }),
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
    },
    async mounted () {
      try {
        await this.$store.dispatch('marketplace/getSpecialists')
          .then((response) => console.log('response: ', response) )
          .catch((error) => console.error(error) );
      } catch (error) {
        console.error(error)
      }
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

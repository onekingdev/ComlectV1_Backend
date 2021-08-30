<template lang="pug">
  .marketplace
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
                h3.mb-0 Browse Specialist
            .card-body
              MarketPlaceSearchInput(@searchCompleted="optionsForRequest.tags = $event")
            .card-body
              SpecialistPanel(v-for="specialist in filteredSpecialists" :specialist="specialist" :key="specialist.id" @directMessage="isSidebarOpen = true")
              Loading
              b-pagination(v-if="filteredSpecialists.length && !loading" v-model='currentPage' :total-rows='rows' :per-page='perPage' aria-controls='my-table' align="center" pills size="sm")
            .card-body(v-if="!filteredSpecialists.length && !loading")
              EmptyState

      b-sidebar#ProjectSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop right width="60%")
        .card
          .card-header.borderless
            .d-flex.justify-content-between
              b-button(variant="default" @click="isSidebarOpen = false") < Close
              div
                a.btn.btn-default(href="#") Send
                a.btn.btn-default.m-l-1(href="#") Share
            .d-flex.justify-content-between.m-t-1
              h4 Messages Details
              div
</template>

<script>
  import { mapGetters } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import MarketPlaceFilter from './components/MarketPlaceFilter'
  import MarketPlaceSearchInput from './components/MarketPlaceSearchInput'
  import SpecialistPanel from './components/SpecialistPanel'
  import SpecialistDetails from './components/SpecialistDetails'
  import _debounce from 'lodash/debounce'

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
    former_regulator: FORMER_REGULATOR_OPTIONS.map(() => false)
  })

  export default {
    components: {
      Loading,
      SpecialistPanel,
      SpecialistDetails,
      MarketPlaceFilter,
      MarketPlaceSearchInput
    },
    data() {
      return {
        pageTitle: "Specialist Marketplace",
        projects: [],
        filter: initialFilter(),
        isSidebarOpen: false,
        search: null,
        optionsForRequest: {
          tags: [],
          industries: [],
          experienceLevel: [],
          hourlyRate: [1, 500],
          jurisdictions: [],
          formerRegulator: []
        },
        sortOptions: {
          industries: [],
          experienceLevel: [],
          hourlyRate: [],
          jurisdictions: [],
          formerRegulator: []
        },
        perPage: 3,
        currentPage: 1,
      };
    },
    created() {
      this.debouncedSend = _debounce(this.sendRequest, 2000)
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
      sendRequest(newValue) {
        this.sortOptions = {
          ...this.sortOptions,
          ...newValue
        }

        // this.$store.dispatch('marketplace/getSpecialistsByFilter', data)
        //   .then((response) => console.log('response: ', response) )
        //   .catch((error) => console.error(error) );
      },
      refetch() {
        const headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': localStorage.getItem('app.currentUser.token') ? JSON.parse(localStorage.getItem('app.currentUser.token')) : '',
        }
        const business_id = window.localStorage["app.business_id"]
        if(business_id) headers.business_id = JSON.parse(business_id)

        fetch(endpointUrl + this.filterQuery, headers)
          .then(response => response.json())
          .then(result => this.projects = result.map(parse))
      },
      closeSidebar() {
        history.pushState({}, '', '/business/specialists')
        this.isSidebarOpen = false
      }
    },
    computed: {
      ...mapGetters({
        specialists: 'marketplace/specialists'
      }),
      loading() {
        return this.$store.getters.loading;
      },
      filteredSpecialists() {
        const sameLowercaseName = (a, b) => a.name.toLowerCase() === b.name.toLowerCase()

        const filterIndustries = specialist => {
          if (!this.optionsForRequest.industries || !this.optionsForRequest.industries.length) return true
          return specialist.industries.find(industry => this.optionsForRequest.industries
            .find(inputIndustry => sameLowercaseName(industry, inputIndustry)))
        }

        const filterJurisdictions = specialist => {
          if (!this.optionsForRequest.jurisdictions || !this.optionsForRequest.jurisdictions.length) return true
          return specialist.jurisdictions.find(jurisdiction => this.optionsForRequest.jurisdictions
            .find(inputJurisdiction => sameLowercaseName(jurisdiction, inputJurisdiction)))
        }

        const filterTags = specialist => {
          if (!this.optionsForRequest.tags || !this.optionsForRequest.tags.length) return true
          return this.optionsForRequest.tags.every(tag => {
            const specialistString = JSON.stringify(Object.values(specialist)).toLowerCase()
            return new RegExp(tag, 'ig').test(specialistString)
          })
        }

        const filterExperience = specialist => {
          if (!this.optionsForRequest.experienceLevel || !this.optionsForRequest.experienceLevel.length) return true
          const levels = ['Junior', 'Intermediate', 'Expert']
          const specialistLevel = levels.indexOf(specialist.experience)
          return this.optionsForRequest.experienceLevel.includes(specialistLevel)
        }

        const filterHourlyRate = specialist => {
          const [min, max] = this.optionsForRequest.hourlyRate
          return specialist.min_hourly_rate >= min && specialist.min_hourly_rate <= max
        }

        return this.specialists
          .filter(filterIndustries)
          .filter(filterJurisdictions)
          .filter(filterTags)
          .filter(filterExperience)
          .filter(filterHourlyRate)
      },
      pricingTypeOptions: () => PRICING_TYPE_OPTIONS,
      experienceOptions: () => EXPERIENCE_OPTIONS,
      budgetOptions: () => BUDGET_OPTIONS,
      durationOptions: () => DURATION_OPTIONS,
      formerRegulatorOptions: () => FORMER_REGULATOR_OPTIONS,
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
      rows() {
        return this.specialists.length
      }
    },
    async mounted () {
      await this.$store.dispatch('marketplace/getSpecialists')
        .catch(error => console.error(error))
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

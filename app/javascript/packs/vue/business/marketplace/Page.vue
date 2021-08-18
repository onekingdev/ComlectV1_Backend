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
              MarketPlaceSearchInput(@searchComplited="filterByInput")
            .card-body
              SpecialistPanel(v-for="specialist in filteredSpecialists" :specialist="specialist" :key="specialist.id" @directMessage="isSidebarOpen = true")
              Loading
              b-pagination(v-if="filteredSpecialists.length && !loading" v-model='currentPage' :total-rows='rows' :per-page='perPage' aria-controls='my-table' align="center" pills size="sm")
            //.card-body.m-2.text-danger(v-if="!specialists && !specialists.length"  title="No specialists")
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
    industries: '',
    jurisdictions: ''
  })

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states'],
    components: {
      Loading,
      // VueRangeSlider,
      SpecialistPanel,
      SpecialistDetails,
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
          industries: [],
          experienceLevel: [],
          hourlyRate: [3, 100],
          jurisdictions: [],
          formerRegulator: []
        },
        sortOptions: {
          tags: [],
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
        this.sortOptions = {
          ...this.sortOptions,
          ...newValue
        }

        // const data = {
        //   min_hourly_rate: newValue.hourlyRate
        // }
        //
        // this.$store.dispatch('marketplace/getSpecialistsByFilter', data)
        //   .then((response) => console.log('response: ', response) )
        //   .catch((error) => console.error(error) );
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
        history.pushState({}, '', '/business/specialists')
        this.isSidebarOpen = false
      },
      applyUrl(project) {
        return `/projects/${project.id}/applications/new`
      },
      filterByInput (values) {
        // console.log('value', values)
        this.sortOptions.tags = values
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
        const defaultSpecialists = this.specialists
        let filteredSpecialists = []

        if(this.sortOptions.industries.length) {
          const sortOption = this.sortOptions.industries

          for (const industry of sortOption) {
            for (const specialist of defaultSpecialists) {
              for (const ind of specialist.industries) {
                if(ind.name.toLowerCase() === industry.name.toLowerCase()) {
                  if(!filteredSpecialists.includes(specialist)) filteredSpecialists.push(specialist)
                }
              }
            }
          }

          return filteredSpecialists
        }

        if(this.sortOptions.tags.length) {
          const sortOption = this.sortOptions

          for (const tag of sortOption.tags) {
            defaultSpecialists.map(specialist => {
              // const name = specialist.first_name.toLowerCase() === tag.toLowerCase()
              // const surname = specialist.last_name.toLowerCase() === tag.toLowerCase()

              for (const [key, value] of Object.entries(specialist)) {

                // console.log(`${key}: ${value}`)
                if (typeof value === 'string') {
                  var myString = specialist[key].toLowerCase()
                  var myWord = tag.toLowerCase()
                  var a = new RegExp('\\b' + myWord + '\\b');

                  if (a.test(myString)) {
                    if(!filteredSpecialists.includes(specialist)) filteredSpecialists.push(specialist)
                  }
                }
              }
            })
          }
          return filteredSpecialists
        }

        if(this.sortOptions.experienceLevel.length) {
          const sortOption = this.sortOptions.experienceLevel

          for (const level of sortOption) {
            let numLevel = null
            if (level === 'Junior') numLevel = 0
            if (level === 'Intermediate') numLevel = 1
            if (level === 'Expert') numLevel = 2

            for (const specialist of defaultSpecialists) {
              if(specialist.experience === numLevel) {
                if(!filteredSpecialists.includes(specialist)) filteredSpecialists.push(specialist)
              }
            }
          }

          return filteredSpecialists
        }

        if(this.sortOptions.jurisdictions.length) {
          const sortOption = this.sortOptions.jurisdictions

          for (const industry of sortOption) {
            for (const specialist of defaultSpecialists) {
              for (const ind of specialist.jurisdictions) {
                if(ind.name.toLowerCase() === industry.name.toLowerCase()) {
                  if(!filteredSpecialists.includes(specialist)) filteredSpecialists.push(specialist)
                }
              }
            }
          }

          return filteredSpecialists
        }

        // if(this.sortOptions.hourlyRate.length) {
        //   const [min, max] = this.sortOptions.hourlyRate
        //
        //   for (const specialist of defaultSpecialists) {
        //     const [sMin, sMax] = this.specialist.hourlyRate
        //     if (min >= sMin && max <= sMax) {
        //       if(!filteredSpecialists.includes(specialist)) filteredSpecialists.push(specialist)
        //     }
        //   }
        //
        //   return filteredSpecialists
        // }

        return defaultSpecialists
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
      rows() {
        return this.specialists.length
      }
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

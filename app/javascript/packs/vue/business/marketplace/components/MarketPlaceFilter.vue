<template lang="pug">
  .card#sidebarMenu_alt
    .card-header(style='border-bottom: 0px;')
      b Filters
    .card-body
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_industry)
        | Industry
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_industry(visible)
        // b-form-input(v-model="filter.industry")
        div(:class="{ 'invalid': errors.industry }")
          multiselect#selectS-1(
            v-model="filter.industry"
            :options="filter.industryOptions"
            :multiple="true"
            :show-labels="false"
            track-by="name",
            label="name",
            placeholder="Select industry",
            required)
          .invalid-feedback.d-block(v-if="errors.industry") {{ errors.industry }}
      hr
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_experience)
        | Experience Level
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_experience(visible)
        b-form-checkbox(v-for="(option, i) in experienceOptions" :value="experienceOptions[i]" v-model="optionsForRequest.experienceLevel" :key="'e'+i") {{ option }}
      hr
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_hourly_rate)
        | Hourly rate
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_hourly_rate(visible)
        <!--b-form-checkbox(v-for="(option, i) in pricingTypeOptions" v-model="filter.pricing_type[i]" :key="'hr'+i") {{option.label}}-->
        VueRangeSlider.mb-5(
        v-bind="vueRangeOptions"
        ref='slider' v-model='optionsForRequest.hourlyRate')
      hr
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_jurisdiction)
        | Jurisdiction
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_jurisdiction(visible)
        // b-form-input(v-model="filter.jurisdiction")
        div(:class="{ 'invalid': errors.jurisdiction }")
          multiselect#selectS-2(
            v-model="filter.jurisdiction"
            :options="filter.jurisdictionOptions"
            :multiple="true"
            :show-labels="false"
            track-by="name",
            label="name",
            placeholder="Select jurisdiction",
            required)
          .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction }}
      hr
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_fromer_regulator)
        | Former Regulator
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_fromer_regulator(visible)
        b-form-checkbox(v-for="(option, i) in regulatorOptions" :value="regulatorOptions[i]" v-model="optionsForRequest.formerRegulator" :key="i") {{ option }}
</template>

<script>
import 'vue-range-component/dist/vue-range-slider.css'
import VueRangeSlider from 'vue-range-component'
import Multiselect from 'vue-multiselect'

export default {
  name: 'MarketPlaceFilter',
  components: {
    VueRangeSlider,
    Multiselect
  },
  props: {
    filter: {
      type: Object,
      required: true
    },
    optionsForRequest: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      errors: {},
      industryOptions: [],
      jurisdictionOptions: [],
      experienceOptions: ['Junior', 'Intermediate', 'Expert'],
      regulatorOptions: ['SEC', 'FINRA', 'State', 'International'],
      vueRangeOptions: {
        min: 0,
        max: 500,
        bgStyle: {
          backgroundColor: '#fff',
          boxShadow: 'inset 0.5px 0.5px 3px 1px rgba(0,0,0,.36)'
        },
        tooltipStyle: {
          color: '#303132',
          backgroundColor: 'transparent',
          border: 'none',
          marginTop: '-9px'
        },
        labelStyle: {
          bottom: 0
        },
        processStyle: {
          backgroundColor: '#303132'
        },
        sliderStyle: {
          backgroundColor: '#303132',
        },
        tooltipMerge: false,
        formatter: value => `$${value}`,
        tooltipDir: 'bottom'
      }
    }
  }
}
</script>

<style>
/* It's need to remove top triangles of points in vue-range-slider */
.vue-range-slider.slider-component .slider-tooltip-wrap.slider-tooltip-bottom .slider-tooltip::before {
  display: none;
}
.custom-control {
  margin-bottom: 10px;
}
.custom-control-label {
  padding-left: 10px;
  padding-top: 4px;
}
.custom-control-label::before {
  width: 20px;
  height: 20px;
}
.custom-control-input:checked ~ .custom-control-label::before {
  background-color: #303132;    border: 0;
  width: 20px;
  height: 20px;
  border-radius: 4px;
}
.custom-checkbox .custom-control-input:checked ~ .custom-control-label::after {
  background-size: 70%;
  background-position: center center;
  width: 20px;
  height: 20px;
}
</style>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>
  /* MULTISELECT */
  .multiselect {
    min-height: 20px;
  }
  .multiselect__placeholder {
    margin-bottom: 0;
    padding-top: 0;
    padding-bottom: 2px;
  }
  .multiselect__tags {
    min-height: 20px;
    padding: 5px 40px 0 10px;
    margin-bottom: 0;
    border-color: #ced4da;
  }
  .multiselect__tag {
    padding: 2px 26px 2px 10px;
    margin-bottom: 0;
    color: #303132;
    background: white;
    border: solid 1px #ced4da;
  }
  .multiselect__tag-icon:after {
    color: #303132;
  }
  .multiselect__option--highlight {
    color: #303132;
    background: #ecf4ff;
  }
  .multiselect__option--highlight::after{
    background: #303132;
  }
  .multiselect__tag-icon {
    line-height: 1.2rem;
  }
  .multiselect__tag-icon:hover {
    color: white;
    background: #303132;
  }
  .multiselect__select {
    height: 30px;
  }
  .multiselect__single {
    margin-bottom: 0;
    font-size: 1.2rem;
    line-height: 14px;
  }
</style>

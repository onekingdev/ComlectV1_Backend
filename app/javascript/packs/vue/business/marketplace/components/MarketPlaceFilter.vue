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
            v-model="optionsForRequest.industries"
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
        <!--VueRangeSlider.mb-5(-->
        <!--v-bind="vueRangeOptions"-->
        <!--ref='slider' v-model='optionsForRequest.hourlyRate')-->
        <!--vue-range-slider.mb-5(-->
        <!--ref='slider' v-model='value'-->
        <!--:min="min" :max="max" :formatter="formatter" :tooltip-merge="tooltipMerge" :enable-cross="enableCross"-->
        <!--:bgStyle="bgStyle" :tooltipStyle="tooltipStyle" :processStyle="processStyle" :slider-style="sliderStyle"-->
        <!--:tooltip-dir='tooltipDir')-->
        .sliedr-contaner
          vue-slider(v-model="optionsForRequest.hourlyRate" :enable-cross="false" v-bind="options")
      hr
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_jurisdiction)
        | Jurisdiction
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_jurisdiction(visible)
        // b-form-input(v-model="filter.jurisdiction")
        div(:class="{ 'invalid': errors.jurisdictions }")
          multiselect#selectS-2(
            v-model="optionsForRequest.jurisdictions"
            :options="filter.jurisdictionOptions"
            :multiple="true"
            :show-labels="false"
            track-by="name",
            label="name",
            placeholder="Select jurisdiction",
            required)
          .invalid-feedback.d-block(v-if="errors.jurisdictions") {{ errors.jurisdictions }}
      hr
      h3.d-flex.justify-content-between(role="button" v-b-toggle.collapse_fromer_regulator)
        | Former Regulator
        ion-icon(name='chevron-down-outline')
      b-collapse#collapse_fromer_regulator(visible)
        b-form-checkbox(v-for="(option, i) in regulatorOptions" :value="regulatorOptions[i]" v-model="optionsForRequest.formerRegulator" :key="i") {{ option }}
</template>

<script>
// import 'vue-range-component/dist/vue-range-slider.css'
// import VueRangeSlider from 'vue-range-component'

import VueSlider from 'vue-slider-component'
import 'vue-slider-component/theme/default.css'

import Multiselect from 'vue-multiselect'

export default {
  name: 'MarketPlaceFilter',
  components: {
    VueSlider,
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
  created() {
    if (this.initialOpenId) {
      this.openDetails(this.initialOpenId)
    }

    // this.min = 0
    // this.max = 250
    // this.bgStyle = {
    //   backgroundColor: '#fff',
    //   boxShadow: 'inset 0.5px 0.5px 3px 1px rgba(0,0,0,.36)'
    // }
    // this.tooltipStyle = {
    //   // color: '#303132',
    //   backgroundColor: '#303132',
    //   borderColor: '#303132'
    // }
    // this.processStyle = {
    //   backgroundColor: '#303132'
    // },
    // this.sliderStyle = {
    //   backgroundColor: '#303132',
    // },
    // this.enableCross = false,
    // this.tooltipMerge = false,
    // this.formatter = value => `$${value}`,
    // this.tooltipDir = 'bottom'
  },
  data () {
    return {
      errors: {},
      industryOptions: [],
      jurisdictionOptions: [],
      experienceOptions: ['Junior', 'Intermediate', 'Expert'],
      regulatorOptions: ['SEC', 'FINRA', 'State', 'International'],
      // value: [0, 100],
      options: {
        min: 0,
        max: 500,
        tooltip: 'always',
        tooltipPlacement: 'bottom',
        tooltipFormatter: v => `$${v}`,
      },
      // vueRangeOptions: {
      //   min: 0,
      //   max: 500,
      //   bgStyle: {
      //     backgroundColor: '#fff',
      //     boxShadow: 'inset 0.5px 0.5px 3px 1px rgba(0,0,0,.36)'
      //   },
      //   tooltipStyle: {
      //     color: '#303132',
      //     backgroundColor: 'transparent',
      //     border: 'none',
      //     marginTop: '-9px'
      //   },
      //   labelStyle: {
      //     bottom: 0
      //   },
      //   processStyle: {
      //     backgroundColor: '#303132'
      //   },
      //   sliderStyle: {
      //     backgroundColor: '#303132',
      //   },
      //   tooltipMerge: false,
      //   formatter: value => `$${value}`,
      //   tooltipDir: 'bottom'
      // },
      // value: [0, 100],
      // mainProps: { blank: false, blankColor: '#777', width: 100, height: 100, class: 'm1' }
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
.custom-control-input {
  width: 1.6rem;
  height: 1.7rem;
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
.custom-control-input:not(:disabled):active ~ .custom-control-label::before {
  color: #fff;
  background-color: #2E304F;
  border-color: #2E304F;
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

<style>
  .sliedr-contaner {
    height: 3.5rem;
  }
  .vue-slider-process,
  .vue-slider-dot-handle {
    background-color: #303132;
  }
  .vue-slider-dot-tooltip-inner {
    color: #303132;
    border: none;
    background-color: transparent;
  }
  .vue-slider-dot-tooltip-inner-bottom::after {
    border: none;
  }
  .vue-slider-dot-tooltip-bottom {
    bottom: -5px;
  }
  .vue-slider-rail {
    background-color: #ecf4ff;
  }
</style>

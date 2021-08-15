<template lang="pug">
  div.h-100
    Loading
    .card.financial-card.h-100.m-b-20
      .card-title.financial-card__title.p-x-20
        h2.card-title__name Annual Budget
        .card-title__actions
          //button.btn.btn.btn-default Edit
          b-dropdown#dropdown-form.m-2(ref='dropdown' variant="default" right)
            template(#button-content)
                | Edit
            b-dropdown-form(style="width: 240px;")
              b-form-input.mb-2#dropdown-form-annual-budget(size='sm' placeholder='Annual Budget value')
              b-button(variant='primary' size='sm' @click='onClick') Save
      .card-body.white-card-body.financial-card__body
        .chart
          .d-flex.justify-content-end.mb-3
            p.financial-card__info.mb-0
              b Left:&nbsp;
              span.financial-card__sum $4,000
          AnnualBudgetChart
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import AnnualBudgetChart from './AnnualBudgetChart'

  export default {
    components: {
      Loading,
      AnnualBudgetChart,
    },
    data() {
      return {

      }
    },
    methods: {
      onClick() {
        // Close the menu and (by passing true) return focus to the toggle button
        this.$refs.dropdown.hide(true)
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  }
</script>

<style scoped>

</style>

<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Subscriptions
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  EmptyPlan
            .settings___card--internal.p-y-1
              .row
                .col-md-12
                  h4
                    b Plan
              .row
                .col
                  Plan
            // hr
            // .settings___card--internal.p-y-1
            //   .row
            //     .col-md-6
            //       h4
            //         b Apps
            //     .col-md-6.text-right
            //       b-button.btn(type='button' variant='default') My Apps
            //   .row
            //     .col
            //       AppsTable(:apps="apps")
            //       div(v-if="!apps && apps.length") Apps not avaliable
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  // import AppsTable from "./components/AppsTable";
  import Plan from "./components/Plan";
  import EmptyPlan from "./components/EmptyPlan";

  export default {
    components: {
      EmptyPlan,
      Plan,
      // AppsTable,
      Loading,
    },
    data() {
      return {

      };
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      // apps() {
      //   return [
      //     {
      //     name: 'Redtail',
      //     status: true,
      //     },
      //     {
      //       name: 'Walthbox',
      //       status: false,
      //     }
      //   ]
      // },
    },
    mounted() {

    },
  };
</script>

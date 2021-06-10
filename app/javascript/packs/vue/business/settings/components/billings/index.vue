<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Billings
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row.m-b-2
                .col
                  h4
                    b Payment Method
                .col.text-right
                  b-button.btn.mr-2(type='button' variant='default') Add Method
              .row
                .col
                  PaymentMethod
            hr
            .settings___card--internal.p-y-1
              .row
                .col
                  h4
                    b Invoices
              .row
                .col
                  InvoicesTable(:invoices="invoices")
                  div(v-if="!invoices && invoices.length") Invoices not avaliable
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import InvoicesTable from "./components/InvoicesTable";
  import PaymentMethod from "./components/PaymentMethod";

  export default {
    components: {
      PaymentMethod,
      InvoicesTable,
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
      invoices() {
        return [
          {
            date: '27/11/2020',
            name: 'Plan - Compilance Command Center Subscription',
            type: 'Plan',
            price: '$50'
          },
          {
            date: '28/12/2020',
            name: 'Plan - Compilance Command Center Subscription',
            type: 'Plan',
            price: '$50'
          }
        ]
      },
    },
    mounted() {

    },
  };
</script>

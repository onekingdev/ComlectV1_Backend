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
                  BillingMethodModalAdd(@selected="addMethod")
                    b-button.btn.mr-2.font-weight-bold(type='button' variant='default') Add Method
                  CardModalAdd(:billingMethod="billingMethod")
                    b-button.d-none(ref="special") Card add
              .row
                .col
                  PaymentMethod(:paymentMethods="paymentMethods")
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
  import BillingMethodModalAdd from "./modals/BillingMethodModalAdd";
  import CardModalAdd from "./modals/CardModalAdd";

  export default {
    components: {
      CardModalAdd,
      BillingMethodModalAdd,
      PaymentMethod,
      InvoicesTable,
      Loading,
    },
    data() {
      return {
        userType: 'business',
        billingMethod: '',
        paymentMethods: []
      };
    },
    methods: {
      addMethod(value) {
        this.billingMethod = value
        // this.$root.$emit("bv::show::modal", "CardModalAdd");
        // console.log(this.$root.$emit("bv::show::modal", "CardModalAdd"))
        this.$refs.special.click()
      }
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
      const dataToSend = {
        userType: this.userType,
      }

      this.$store.dispatch('settings/getPaymentMethod', dataToSend)
        .then(response => {
          console.log(response)
          // const newOptions = response.map((card, index) => {
          //   return { text: `Credit Card${index===0 ? ' (primary)' : ''}`, value: card.id, number: `**** **** **** ${card.last4}`, type: card.brand, id: card.id }
          // })
          // console.log(newOptions)
          this.paymentMethods = response
        })
        .catch(error => {
          console.error(error)
        })
    }
  };
</script>

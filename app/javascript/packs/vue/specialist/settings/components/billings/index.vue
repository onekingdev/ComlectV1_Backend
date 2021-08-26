<template lang="pug">
  .row
    .col
      .card.settings__card
        .card-title.px-3.px-xl-5.py-xl-4.mb-0
          h3.mb-0 Billing
        .card-body.white-card-body.px-3.px-xl-5
          .settings___card--internal.p-y-1
            .row.m-b-20
              .col
                h4.mb-0 Client Billing
            .row
              .col
                ClientBilling(@openComponent="openComponent")
          .settings___card--internal.p-y-1
            .row.m-b-20(v-if='!loading')
              .col
                h4.mb-0 Payment Method
              .col.text-right
                BillingMethodModalAdd(@selected="addMethod")
                  b-button.btn.mr-2.font-weight-bold(type='button' variant='default') Add Method
                BillingMethodCardModalAdd(:billingMethod="billingMethod" @complitedPaymentMethod="addPaymentMethod")
                  b-button.d-none(ref="special") Card add
            .row
              .col
                Loading
                PaymentMethod(v-if='!loading' :paymentMethods="paymentMethods")

          .settings___card--internal.p-y-1(v-if='!loading')
            .row
              .col
                h4.mb-0 Invoices
              .col.text-right
                Download(:pdfUrl="pdfUrl")
            .row
              .col
                InvoicesTable(:invoices="invoices")
                div(v-if="!invoices && invoices.length") Invoices not avaliable
</template>

<script>
  import { mapGetters, mapActions } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import InvoicesTable from "./components/InvoicesTable";
  import PaymentMethod from "./components/PaymentMethod";
  import BillingMethodModalAdd from "./modals/BillingMethodModalAdd";
  import BillingMethodCardModalAdd from "./modals/BillingMethodCardModalAdd";
  import ClientBilling from "./components/ClientBilling";
  import Download from '@/common/Dashboard/components/Download'

  const pdfUrl = '/specialist/reminders.csv'

  export default {
    components: {
      BillingMethodCardModalAdd,
      BillingMethodModalAdd,
      PaymentMethod,
      InvoicesTable,
      Loading,
      ClientBilling,
      Download,
    },
    data() {
      return {
        userType: 'specialist',
        billingMethod: '',
        // paymentMethods: []
      };
    },
    methods: {
      ...mapActions({
        getPaymentMethod: 'settings/getPaymentMethod'
      }),
      addMethod(value) {
        this.billingMethod = value
        // this.$root.$emit("bv::show::modal", "CardModalAdd");
        // console.log(this.$root.$emit("bv::show::modal", "CardModalAdd"))
        this.$refs.special.click()
      },
      addPaymentMethod (response) {
        this.paymentMethods.push(response)
      },
      openComponent (value) {
        this.$emit('openComponent', value)
      }
    },
    computed: {
      ...mapGetters({
        loading: 'loading',
        paymentMethods: 'settings/paymentMethods'
      }),
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
      pdfUrl: () => pdfUrl,
    },
    async mounted() {
      try {
        const data = {
          userType: this.userType,
        }
        await this.getPaymentMethod(data)
          .then(response => response)
          .catch(error => console.error(error))
      } catch (error) {
        console.error(error)
      }
    }
  };
</script>

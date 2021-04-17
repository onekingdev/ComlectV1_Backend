<template lang="pug">
  div
    .container
      .row
        .col-12.px-0
          .row.p-x-1
            .col-md-12.d-flex.justify-content-between.p-t-3.p-b-3
              div
                h2: b {{ pageTitle }}
              div
                a.btn.btn-default.mr-3(href='#') Export
                RisksAddEditModal
                  button.btn.btn-dark Add Risk
          .row
            .col-12
              .card-body.white-card-body
                RisksTable

</template>

<script>
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import RisksTable from './RisksTable'
  import RisksAddEditModal from './Modals/RisksAddEditModal'

  export default {
    mixins: [EtaggerMixin()],
    components: {
      RisksTable,
      RisksAddEditModal
    },
    data() {
      return {
        pageTitle: "Risk Register",
      };
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      // risksComputed() {
      //   return this.$store.getters.risksList
      // }
    },
    mounted() {
      // this.$store
      //   .dispatch('getRisks')
      //   .then(response => {
      //     console.log('response', response)
      //     // this.makeToast('Success', `Policy successfully deleted!`)
      //   })
      //   .catch(error => {
      //     console.error(error)
      //     // this.makeToast('Error', `Couldn't submit form! ${error}`)
      //   })
    }
  };
</script>

<style>
  @import "./styles.css";
</style>


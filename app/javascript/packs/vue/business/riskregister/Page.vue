<template lang="pug">
  div
    .page
      h2.page__title {{ pageTitle }}
      .page__actions
        a.btn.btn-default.mr-3(href='#') Export
        RisksAddEditModal
          button.btn.btn-dark Add Risk
    .card-body.white-card-body.card-body_full-height
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


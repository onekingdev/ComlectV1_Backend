<template lang="pug">
  div
    .container
      .row
        .col-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            h2 {{ pageTitle }}
    .container-fluid.p-x-0
      .row
        .col-12.px-0
          .card-body.white-card-body.height-80
            .container
              .row
                .col-12
                  Loading
              .row.p-x-1
                .col-md-7.col-sm-12.pl-0
                  .card
                    RegulatoryExams(:exams="exams")
                .col-md-5.col-sm-12.pl-0
                  .card
                    .card-header.d-flex.justify-content-between
                      h3.m-y-0 Tasks
                      button.btn.btn-dark New Task
                    .card-body
                      Tasks

</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import RegulatoryExams from './components/RegulatoryExams'
  import Tasks from './components/Tasks'

  export default {
    components: {
      Loading,
      RegulatoryExams,
      Tasks
    },
    data() {
      return {
        pageTitle: "Exam Management",
      };
    },
    created() {

    },
    methods: {
      ...mapActions({
        getExams: 'exams/getExams',
      }),
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      ...mapGetters({
        exams: 'exams/exams',
      }),
    },
    async mounted () {
      try {
        await this.getExams()
      } catch (error) {
        console.error(error)
        this.makeToast('Error', error.message)
      }
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

<style scoped>
  .separator {
    color: #ffc107;
  }
</style>

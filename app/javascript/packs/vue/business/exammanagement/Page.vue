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
              .row.p-x-1
                .col-md-7.col-sm-12.pl-0
                  .card
                    RegulatoryExamsTable(:exams="exams")
                .col-md-5.col-sm-12.pl-0
                  Tasks(:shortTable="true")
</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import { DateTime } from 'luxon'
  import RegulatoryExamsTable from './components/ExamsTable'
  import TaskFormModal from '@/common/TaskFormModal'
  import Tasks from '@/business/tasks/Page'

  export default {
    components: {
      RegulatoryExamsTable,
      TaskFormModal,
      Tasks
    },
    data() {
      return {
        pageTitle: "Exam Management",
      };
    },
    methods: {
      ...mapActions({
        getExams: 'exams/getExams',
      }),
    },
    computed: {
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

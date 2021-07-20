<template lang="pug">
  .page
    .page-header
      h2.page-header__title {{ pageTitle }}
    .card-body.white-card-body.card-body_full-height
      .row
        .col-lg-7.col-sm-12.pl-0.mb-3.mb-lg-0
          .card
            RegulatoryExamsTable(:exams="exams")
        .col-lg-5.col-sm-12.pl-0
          .card
            .card-header.d-flex.justify-content-between
              h3.m-y-0 Tasks
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

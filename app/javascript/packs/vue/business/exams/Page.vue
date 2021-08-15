<template lang="pug">
  .page.exam
    .page-header
      h2.page-header__title {{ pageTitle }}
    .card-body.white-card-body.card-body_full-height.p-x-40
      .row
        .col-lg-7.col-sm-12.mb-3.mb-lg-0
          .card
            RegulatoryExamsTable(:exams="exams")
        .col-lg-5.col-sm-12.pl-0
          .card
            .card-header.d-flex.justify-content-between
              h3.m-y-0 Tasks
              TaskModalCreateEdit
                a.btn.btn-dark New Task
            Tasks(:shortTable="true")
</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import { DateTime } from 'luxon'
  import RegulatoryExamsTable from './components/ExamsTable'
  import TaskFormModal from '@/common/TaskFormModal'
  import Tasks from '@/business/tasks/Page'
  import TaskModalCreateEdit from "@/business/tasks/modals/TaskModalCreateEdit";

  export default {
    components: {
      TaskModalCreateEdit,
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
        this.toast('Error', error.message, true)
      }
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

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
                  .card
                    .card-header.d-flex.justify-content-between
                      h3.m-y-0 Tasks
                      TaskFormModal(@saved="$emit('saved')")
                        button.btn.btn-dark New Task
                    .card-body
                      TaskTable(:tasks="tasks" @saved="$emit('saved')")

</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import { DateTime } from 'luxon'
  import RegulatoryExamsTable from './components/ExamsTable'
  import TaskFormModal from '@/common/TaskFormModal'
  import TaskTable from '@/common/TaskTable'

  export default {
    props: {
      etag: Number
    },
    components: {
      RegulatoryExamsTable,
      TaskFormModal,
      TaskTable
    },
    data() {
      return {
        pageTitle: "Exam Management",
        projects: [],
        tasks: [],
      };
    },
    created() {
      this.refetch()
    },
    methods: {
      ...mapActions({
        getExams: 'exams/getExams',
      }),

      // FOR TASKS TIKHON
      refetch() {
        const fromTo = DateTime.local().toSQLDate() + '/' + DateTime.local().plus({days: 7}).toSQLDate()

        fetch(`/api/business/overdue_reminders`, { headers: {'Accept': 'application/json'} })
          .then(response => response.json())
          .then(result => {
            this.tasks = result.tasks
          }).then(fetch(`/api/business/reminders/${fromTo}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => {
            this.tasks = this.tasks.concat(result.tasks)
            this.projects = result.projects
          })
        )
        // .catch(errorCallback)
      }
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
    watch: {
      etag: {
        handler: function(newVal, outline) {
          this.refetch()
        }
      }
    }
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

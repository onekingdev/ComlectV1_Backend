<template lang="pug">
  div
    .page(v-if="!shortTable")
      h2.page__title Tasks
      .page__actions
        a.btn.btn-default.m-r-1(v-if="!shortTable") Download
        TaskModalCreate(@saved="refetch()")
          a.btn.btn-dark Create task
    .card-body.white-card-body
      .row(v-if="!shortTable")
        .col
          .d-flex.align-items-center
            ion-icon.m-r-1(name="chevron-down-outline" size="small")
            b-badge.m-r-1(variant="light") 0
            h3 Compilance Program
      .row
        .col
          Loading
          TaskTable(v-if="!loading && tasks" :shortTable="shortTable", :tasks="tasks")
</template>

<script>
  import { mapGetters } from "vuex"

  import { DateTime } from 'luxon'
  // import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

  import Loading from '@/common/Loading/Loading'
  import TaskFormModal from '@/common/TaskFormModal'
  import TaskModalCreate from './modals/TaskModalCreate'

  import TaskTable from './components/TaskTable'

  // const endpointUrl = '/api/business/reminders/'
  // const overdueEndpointUrl = '/api/business/overdue_reminders'

  // const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
  // console.log(DateTime)
  // console.log(DateTime.local())
  // console.log(DateTime.local().minus({years: 10}))
  // console.log(DateTime.local().minus({years: 10}).toSQLDate())
  // console.log(DateTime.local().plus({years: 10}).toSQLDate())
  // console.log(fromTo)

  export default {
    props: {
      // etag: Number,
      shortTable: {
        type: Boolean,
        default: false
      }
    },
    components: {
      Loading,
      TaskTable,
      TaskFormModal,
      TaskModalCreate
    },
    data() {
      return {
        // tasks: []
      }
    },
    // created() {
      // this.refetch()
    // },
    methods: {
      // refetch() {
      //   const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
      //
      //   fetch(overdueEndpointUrl, { headers: {'Accept': 'application/json'} })
      //     .then(response => response.json())
      //     .then(result => {
      //       console.log('overdue result', result)
      //       this.tasks = result.tasks
      //     }).then(fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
      //     .then(response => response.json())
      //     .then(result => {
      //       console.log('reminders result', result)
      //       this.tasks = this.tasks.concat(result.tasks)
      //       this.projects = result.projects
      //     })
      //   )
      //   // .catch(errorCallback)
      // },
      //
      // isOverdue,
      // toggleDone(task) {
      //   const { taskId, oid } = splitReminderOccurenceId(task.id)
      //   const oidParam = oid !== null ? `&oid=${oid}` : ''
      //   var target_state = (!(!!task.done_at)).toString()
      //   fetch(`/api/business/reminders/${taskId}?done=${target_state}${oidParam}`, {
      //     method: 'POST',
      //     headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      //   }).then(response => this.$emit('saved'))
      // },
      //
      // createTask(i){
      //   console.log('createTask: ', i)
      // },
      // deleteTask(id){
      //   fetch(`${endpointUrl}${id}`, { method: 'DELETE', headers: {'Accept': 'application/json'} })
      //     .then(response => response.json())
      //     .then(response => {
      //       console.log('result', response)
      //       this.makeToast('Success', `Task successfully deleted!`)
      //     })
      //     .catch(error => this.makeToast('Error', `${error.message}`))
      // },
      // makeToast(title, str) {
      //   this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      // },
    },
    computed: {
      ...mapGetters({
        tasks: 'reminders/tasks'
      }),
      // taskEvents() {
      //   return this.tasks.map(toEvent)
      //     .map(e => ({
      //       ...e,
      //       start: DateTime.fromSQL(e.start).toLocaleString(),
      //       end: DateTime.fromSQL(e.end).toLocaleString(),
      //       ...splitReminderOccurenceId(e.id)
      //     }))
      // },
      loading() {
        return this.$store.getters.loading;
      },
    },
    async mounted () {
      try {
        // await this.$store.dispatch('reminders/getTasks')

        const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
        await this.$store.dispatch('reminders/getTasksByDate', fromTo)
          .then(response => console.log('response', response))
          .catch(error => console.error('error', error))
        // await this.$store.dispatch('reminders/getOverdueTasks')
        //   .then(response => console.log('response Overdue', response))
        //   .catch(error => console.error('error', error))
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    // watch: {
      // etag: {
      //   handler: function(newVal, outline) {
      //     this.refetch()
      //   }
      // }
    // }
  }
</script>

<template lang="pug">
  .page
    .page-header(v-if="!shortTable")
      h2.page-header__title Tasks
      .page-header__actions
        a.btn.btn-default.m-r-1(v-if="!shortTable") Download
        TaskModalCreate(@saved="refetch()")
          a.btn.btn-dark New Task
    .card-body.white-card-body.card-body_full-height.p-x-40
      .row.mb-3(v-if="!shortTable")
        .col
          div
            b-dropdown.actions.m-r-1(variant="default")
              template(#button-content)
                | Show: {{ sortedByNameGeneral }}
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item(@click="sortBy('all', 1)") All Tasks
              b-dropdown-item(@click="sortBy('overdue', 1)") Overdue
              b-dropdown-item(@click="sortBy('completed', 1)") Completed
            b-dropdown.actions.m-r-1(variant="default")
              template(#button-content)
                | {{ sortedByNameAdditional }}
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item(@click="sortBy('all', 2)") All Links
              b-dropdown-item(@click="sortBy('LocalProject', 2)") Projects
              b-dropdown-item(@click="sortBy('CompliancePolicy', 2)") Policies
              b-dropdown-item(@click="sortBy('AnnualReport', 2)") Internal Reviews
            b-dropdown.actions.d-none(variant="default")
              template(#button-content)
                | {{ perPage }} results
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item(@click="perPage = 5") 5
              b-dropdown-item(@click="perPage = 10") 10
              b-dropdown-item(@click="perPage = 15") 15
              b-dropdown-item(@click="perPage = 20") 20
      .row.h-100(v-if="!sortedTasks.length && !loading")
        .col.h-100.text-center
          EmptyState(name="Tasks")
      div(v-if="sortedTasks.length")
        //.row(v-if="!shortTable")
        //  .col
        //    .d-flex.align-items-center
        //      ion-icon.m-r-1(name="chevron-down-outline" size="small")
        //      b-badge.m-r-1(variant="light") 0
        //      h3 Compilance Program
        .row
          .col
            Loading(:absolute="true")
            TaskTable.m-b-40(v-if="tasks" :shortTable="shortTable", :tasks="sortedTasks" :perPage="perPage" :currentPage="currentPage")
            b-pagination(v-if="!shortTable && sortedTasks.length >= perPage" v-model='currentPage' :total-rows='rows' :per-page='perPage' :shortTable="!shortTable",  aria-controls='tasks-table')

</template>

<script>
  import { mapGetters } from "vuex"

  import { DateTime } from 'luxon'
  import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

  import Loading from '@/common/Loading/Loading'
  import EmptyState from '@/common/EmptyState'
  import TaskTable from './components/TaskTable'
  import TaskModalCreate from './modals/TaskModalCreate'
  // import TaskModalEdit from './modals/TaskModalEdit'

  // const endpointUrl = '/api/business/reminders/'
  // const overdueEndpointUrl = '/api/business/overdue_reminders'

  // const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
  // console.log(DateTime)
  // console.log(DateTime.local())
  // console.log(DateTime.local().minus({years: 10}))
  // console.log(DateTime.local().minus({years: 10}).toSQLDate())
  // console.log(DateTime.local().plus({years: 10}).toSQLDate())
  // console.log(fromTo)

  // const today = () => DateTime.local().toISODate()

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
      EmptyState,
      TaskTable,
      TaskModalCreate,
      // TaskModalEdit
    },
    data() {
      return {
        // tasks: [],
        perPage: 10,
        currentPage: 1,
        toggleModal: false,
        sortedBy: '',
        sortedByNameGeneral: 'All Tasks',
        sortedByNameAdditional: 'All Links',
        projects: []
      }
    },
    // created() {
      // this.refetch()
    // },
    methods: {
      refetch() {
        console.log('refetch')
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
      },
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
      sortBy (value, num) {
        this.sortedBy = value
        const upperFirst = value.charAt(0).toUpperCase() + value.slice(1)
        if (num === 1) this.sortedByNameGeneral = upperFirst
        if (num === 2) this.sortedByNameAdditional = upperFirst
      }
    },
    computed: {
      ...mapGetters({
        tasks: 'reminders/tasks',
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
      rows() {
        return this.tasks.length
      },
      sortedTasks () {
        const sortBy = this.sortedBy

        let result
        if (sortBy === 'completed')
          result = this.tasks.filter(task => task.done_at)
        if (sortBy === 'overdue')
          result = this.tasks.filter(task => isOverdue(task))
        if (sortBy === 'all')
          result = this.tasks
        if (sortBy === 'LocalProject' || sortBy === 'CompliancePolicy'|| sortBy === 'AnnualReport')
          result = this.tasks.filter(task => task.linkable_type === sortBy)

        return result ? result : this.tasks
      }
    },
    async mounted () {
      try {
        // await this.$store.dispatch('reminders/getTasks')

        const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
        await this.$store.dispatch('reminders/getTasksByDate', fromTo)
          .then(response => {
            console.log('response', response)
            if (response.projects) this.projects = response.projects
          })
          .catch(error => console.error('error', error))
        //await this.$store.dispatch('reminders/getOverdueTasks')
        //  .then(response => console.log('response Overdue', response))
        //  .catch(error => console.error('error', error))
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

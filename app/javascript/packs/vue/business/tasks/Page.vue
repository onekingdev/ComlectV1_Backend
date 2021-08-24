<template lang="pug">
  .page
    .page-header(v-if="!shortTable")
      h2.page-header__title Tasks
      .page-header__actions
        //a.btn.btn-default.m-r-1(v-if="!shortTable" :href="pdfUrl" target="_blank") Download
        Download.d-inline-block.m-r-1(v-if="!shortTable" :pdfUrl="pdfUrl")
        TaskModalCreateEdit(:toastMessages="toastMessages" @saved="refetch()")
          a.btn.btn-dark New Task
    .card-body.white-card-body.card-body_full-height.p-x-40
      .row.mb-3(v-if="!shortTable")
        .col
          div
            b-dropdown.actions__dropdown.actions__dropdown_tasks.m-r-1(variant="default")
              template(#button-content)
                | Show: {{ sortedByNameGeneral | capitalize }}
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item(@click="sortBy('all')") All
              b-dropdown-item(@click="sortBy('overdue')") Overdue
              b-dropdown-item(@click="sortBy('completed')") Completed
            b-dropdown.actions__dropdown.actions__dropdown_links.m-r-1(variant="default")
              template(#button-content)
                | {{ sortedByNameAdditional | capitalize | linkableTypeCorrector }}
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item(@click="sortByType('all')") All
              b-dropdown-item(@click="sortByType('LocalProject')") Projects
              b-dropdown-item(@click="sortByType('CompliancePolicy')") Policies
              b-dropdown-item(@click="sortByType('AnnualReport')") Internal Reviews
            b-dropdown.actions__dropdown.d-none(variant="default")
              template(#button-content)
                | {{ perPage }} results
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item(@click="perPage = 5") 5
              b-dropdown-item(@click="perPage = 10") 10
              b-dropdown-item(@click="perPage = 15") 15
              b-dropdown-item(@click="perPage = 20") 20
      //.row(v-if="!shortTable")
      //  .col
      //    .d-flex.align-items-center
      //      ion-icon.m-r-1(name="chevron-down-outline" size="small")
      //      b-badge.m-r-1(variant="light") 0
      //      h3 Compilance Program
      .row
        .col(:class="shortTable ? 'p-0' : ''")
          TaskTable.m-b-40(:shortTable="shortTable", :tasks="sortedTasks" :perPage="perPage" :currentPage="currentPage" :toastMessages="toastMessages")
          b-pagination(v-if="!shortTable && sortedTasks.length > perPage" v-model='currentPage' :total-rows='rows' :per-page='perPage' :shortTable="!shortTable",  aria-controls='tasks-table')
      .row.h-100(v-if="loading")
        .col.h-100.text-center
          Loading(:absolute="true")
      .row.h-100(v-if="!sortedTasks.length && !loading")
        .col.h-100.text-center
          EmptyState(name="Tasks")
</template>

<script>
  import { mapGetters } from "vuex"

  import { DateTime } from 'luxon'
  import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

  import Loading from '@/common/Loading/Loading'
  import EmptyState from '@/common/EmptyState'
  import TaskTable from './components/TaskTable'
  import TaskModalCreateEdit from './modals/TaskModalCreateEdit'
  // import TaskModalEdit from './modals/TaskModalEdit'
  import Download from '@/common/Dashboard/components/Download'

  import toastMessages from '@/locales/business/en.json'


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

  const pdfUrl = '/reminders.csv'

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
      TaskModalCreateEdit,
      // TaskModalEdit,
      Download
    },
    data() {
      return {
        // tasks: [],
        perPage: 10,
        currentPage: 1,
        toggleModal: false,
        sortedBy: 'all',
        sortedByLinkedTo: 'all',
        sortedByNameGeneral: 'All Tasks',
        sortedByNameAdditional: 'All Links',
        projects: [],
        toastMessages: toastMessages.tasks
      }
    },
    // created() {
      // this.refetch()
    // },
    methods: {
      async mounted () {
        try {
          // await this.$store.dispatch('reminders/getTasks')

          const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
          await this.$store.dispatch('reminders/getTasksByDate', fromTo)

          // const data = await this.$store.dispatch('reminders/getTasksByDate', fromTo)
          // if (data) console.log('data getTasksByDate', data)

          // const dataOverdue = await this.$store.dispatch('reminders/getOverdueTasks')
          // if (dataOverdue) console.log('data getOverdueTasks', data)

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
      refetch() {
        console.log('refetch')

        // HOOK to GET REPEATING Tasks
        this.getData()

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
      //       this.toast('Success', `Task has been deleted.`)
      //     })
      //     .catch(error => this.toast('Error', Task has not been deleted. Please try again.`))
      // },
      // toast(title, str) {
      //   this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      // },
      sortBy (value) {
        this.sortedBy = value
        this.sortedByNameGeneral = value
      },
      sortByType (value) {
        this.sortedByLinkedTo = value
        this.sortedByNameAdditional = value
      },
      async getData() {
        try {
          // await this.$store.dispatch('reminders/getTasks')

          const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
          await this.$store.dispatch('reminders/getTasksByDate', fromTo)

          // const data = await this.$store.dispatch('reminders/getTasksByDate', fromTo)
          // if (data) console.log('data getTasksByDate', data)

          // const dataOverdue = await this.$store.dispatch('reminders/getOverdueTasks')
          // if (dataOverdue) console.log('data getOverdueTasks', data)

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
    computed: {
      ...mapGetters({
        tasks: 'reminders/tasks',
      }),
      pdfUrl: () => pdfUrl,
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
        const sortedBy = this.sortedBy
        const sortedByType = this.sortedByLinkedTo

        let result

        const tasksWithOid = this.tasks.map(task => {
          const { taskId, oid } = splitReminderOccurenceId(task.id)
          return {
            ...task,
            taskId: taskId,
            oid: oid
          }
        })

        if (sortedBy) {
          if (sortedBy === 'completed')
            result = tasksWithOid.filter(task => task.done_at)
          if (sortedBy === 'overdue')
            result = tasksWithOid.filter(task => isOverdue(task))
          if (sortedBy === 'all')
            result = tasksWithOid
        }

        if (sortedByType) {
          if (sortedByType === 'LocalProject' || sortedByType === 'CompliancePolicy'|| sortedByType === 'AnnualReport')
            result = result.filter(task => task.linkable_type === sortedByType)
          if (sortedByType === 'all')
            result = result ? result : tasksWithOid
        }

        return result ? result : tasksWithOid
      },
    },
    async mounted () {
      this.getData()
    },
    // watch: {
      // etag: {
      //   handler: function(newVal, outline) {
      //     this.refetch()
      //   }
      // }
    // }
    filters: {
      capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      },
      linkableTypeCorrector: function (value) {
        if (value === 'LocalProject') value = 'Projects'
        if (value === 'CompliancePolicy') value = 'Policies'
        if (value === 'AnnualReport') value = 'Internal Review'
        return value.replace(/[A-Z]/g, ' $&')
      }
    },
  }
</script>

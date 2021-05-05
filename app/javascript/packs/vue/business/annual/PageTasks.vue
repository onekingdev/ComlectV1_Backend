<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card.px-5
          .reviews__topiclist
            .reviews__card--internal.p-y-1
              .row.m-b-2
                .col-md-12.d-flex.justify-content-between
                  h2 Tasks
                  div
                    a.btn.btn-default.m-r-1 Download
                    AnnualModalCreateTask(@saved="createTask(i)")
                      a.btn.btn-dark Create task
              hr
              .row
                .col
                  table.table.task_table
                    thead
                      tr
                        th(width="40%")
                          | Name
                          b-icon.ml-2(icon='chevron-expand')
                        th
                          | Assignee
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right
                          | Start date
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right
                          | Due date
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right
                          | Files
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right
                          | Comments
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right(width="10%")
                    tbody
                      tr(v-for="(task, i) in tasks" :key="i")
                        td
                          ion-icon.m-r-1.pointer(@click="toggleDone(task)" v-bind:class="{ done_task: task.done_at }" name='checkmark-circle-outline')
                          TaskFormModal(:task-id="task.taskId" :occurence-id="task.oid" @saved="$emit('saved')") {{ task.body }}
                        td {{ task.assignee }}
                        td.text-right(:class="{ overdue: isOverdue(task) }") {{ task.remind_at }}
                        td.text-right(:class="{ overdue: isOverdue(task) }") {{ task.end_date }}
                        td.text-right 0
                        td.text-right 0
                        td.text-right
                          b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                            template(#button-content)
                              b-icon(icon="three-dots")
                            b-dropdown-item {{ task.done_at ? 'Incomplite' : 'Complite' }}
                            b-dropdown-item(@click="deleteTask(task.id)").delete Delete Task

</template>

<script>
  import { DateTime } from 'luxon'
  import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

  import TaskFormModal from '@/common/TaskFormModal'
  import AnnualModalCreateTask from './modals/AnnualModalCreateTask'

  const endpointUrl = '/api/business/reminders/'
  const overdueEndpointUrl = '/api/business/overdue_reminders'

  export default {
    components: {
      TaskFormModal,
      AnnualModalCreateTask
    },
    data() {
      return {
        tasks: []
      }
    },
    created() {
      this.refetch()
    },
    methods: {
      refetch() {
        const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()

        fetch(overdueEndpointUrl, { headers: {'Accept': 'application/json'} })
          .then(response => response.json())
          .then(result => {
            console.log('result', result)
            this.tasks = result.tasks
          }).then(fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => {
            console.log('result2', result)
            this.tasks = this.tasks.concat(result.tasks)
            this.projects = result.projects
          })
        )
        // .catch(errorCallback)
      },

      isOverdue,
      toggleDone(task) {
        const { taskId, oid } = splitReminderOccurenceId(task.id)
        const oidParam = oid !== null ? `&oid=${oid}` : ''
        var target_state = (!(!!task.done_at)).toString()
        fetch(`/api/business/reminders/${taskId}?done=${target_state}${oidParam}`, {
          method: 'POST',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        }).then(response => this.$emit('saved'))
      },

      createTask(i){
        console.log('createTask: ', i)
      },
      deleteTask(id){
        fetch(`${endpointUrl}${id}`, { method: 'DELETE', headers: {'Accept': 'application/json'} })
          .then(response => response.json())
          .then(response => {
            console.log('result', response)
            this.makeToast('Success', `Task successfully deleted!`)
          })
        .catch(error => this.makeToast('Error', `${error.message}`))
      },
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
    },
    computed: {
      taskEvents() {
        return this.tasks.map(toEvent)
          .map(e => ({
            ...e,
            start: DateTime.fromSQL(e.start).toLocaleString(),
            end: DateTime.fromSQL(e.end).toLocaleString(),
            ...splitReminderOccurenceId(e.id)
          }))
      }
    },
  }
</script>

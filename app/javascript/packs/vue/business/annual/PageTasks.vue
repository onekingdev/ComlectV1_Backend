<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card.px-5
          .reviews__topiclist
            .reviews__card--internal.p-y-1
              .row.m-b-2
                .col-md-12.d-flex.justify-content-between
                  h2: b Tasks
                  div
                    a.btn.btn-default Download
                    a.btn.m-l-1.btn-dark Create Task
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
                          TaskFormModal(:task-id="task.id" :occurence-id="task.oid" @saved="$emit('saved')") {{ task.body }}
                        td {{ task.assignee }}
                        td.text-right(:class="{ overdue: isOverdue(task) }") {{ task.remind_at }}
                        td.text-right(:class="{ overdue: isOverdue(task) }") {{ task.end_date }}
                        td.text-right 0
                        td.text-right 0
                        td.text-right
                          b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                            template(#button-content)
                              b-icon(icon="three-dots")
                            b-dropdown-item Some action
                            b-dropdown-item(@click="deleteTask(i)").delete Delete Task

</template>

<script>
  const endpointUrl = '/api/business/reminders/'
  const overdueEndpointUrl = '/api/business/overdue_reminders'
  import { DateTime } from 'luxon'
  import TaskFormModal from '@/common/TaskFormModal'
  import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

  export default {
    components: {
      TaskFormModal
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
            this.tasks = result.tasks
          }).then(fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => {
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

      deleteTask(i){
        console.log('delete', i)
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

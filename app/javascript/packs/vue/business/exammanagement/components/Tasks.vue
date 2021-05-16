<template lang="pug">
  table.table.task_table
    thead
      tr
        th(width="40%")
          | Name
          b-icon.ml-2(icon='chevron-expand')
        th.text-right
          | Due date
          b-icon.ml-2(icon='chevron-expand')

    tbody
      tr(v-for="(task, i) in tasks" :key="i")
        td
          ion-icon.m-r-1.pointer(@click="toggleDone(task)" v-bind:class="{ done_task: task.done_at }" name='checkmark-circle-outline')
          TaskFormModal(:task-id="task.taskId" :occurence-id="task.oid" @saved="$emit('saved')") {{ task.body }}
        td.text-right(:class="{ overdue: isOverdue(task) }") {{ task.end_date }}
</template>

<script>
  import { DateTime } from 'luxon'
  import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

  import TaskFormModal from '@/common/TaskFormModal'

  const endpointUrl = '/api/business/reminders/'
  const overdueEndpointUrl = '/api/business/overdue_reminders'

  export default {
    props: {
      etag: Number
    },
    components: {
      TaskFormModal,
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
    watch: {
      etag: {
        handler: function(newVal, outline) {
          this.refetch()
        }
      }
    }
  }
</script>

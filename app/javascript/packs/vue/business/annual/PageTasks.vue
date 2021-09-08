<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card
          .reviews__topiclist
            .reviews__card--header.p-b-20
              h2 Tasks
              div
                a.btn.btn-default.m-r-1.d-none Download
                TaskFormModal(:defaults="taskDefaults" @saved="$emit('saved')")
                  a.btn.btn-dark New task
            .reviews__card--internal.borderless
              table.table.task_table
                thead
                  tr
                    th(width="45%")
                      span.pointer(@click="toggleSorting('body')")
                        | Name
                        b-icon.ml-2(icon='chevron-expand')
                    th
                      span.pointer(@click="toggleSorting('assignee_name')")
                        | Assignee
                        b-icon.ml-2(icon='chevron-expand')
                    th
                      span.pointer(@click="toggleSorting('remind_at')")
                        | Start Date
                        b-icon.ml-2(icon='chevron-expand')
                    th
                      span.pointer(@click="toggleSorting('end_date')")
                        | Due Date
                        b-icon.ml-2(icon='chevron-expand')
                    th(width="35px")
                tbody.text-dark(v-if="tasksSorted && tasksSorted.length")
                  tr(v-for="task in tasksSorted" :key="task.id")
                    td {{ task.body }}
                    td {{ task.assignee_name || '' }}
                    td {{ task.remind_at | asDate }}
                    td {{ task.end_date | asDate }}
                    td.actions
                      b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
                        template(#button-content)
                          b-icon(icon="three-dots")
                        b-dropdown-item-button Edit
                        b-dropdown-item-button Delete
              EmptyState
</template>

<script>
import TaskFormModal from '@/common/TaskFormModal'

export default {
  props: {
    review: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      sortField: null,
      sortDirection: 1
    }
  },
  methods: {
    toggleSorting(field, startDescending = false) {
      const initialDirection = startDescending ? -1 : 1
      this.sortDirection = this.sortField === field ? -1 * this.sortDirection : initialDirection
      this.sortField = field
    },
  },
  computed: {
    tasksSorted() {
      if (this.sortField) {
        const compare = (aField, bField) => {
          const [a, b] = [aField[this.sortField], bField[this.sortField]]
          return a > b ? this.sortDirection : (a < b ? (this.sortDirection * -1) : 0)
        }
        return this.review.reminders.sort(compare)
      }
      return this.review.reminders
    },
    taskDefaults() {
      return {
        linkable_type: 'AnnualReport',
        linkable_id: this.review.id
      }
    }
  },
  components: {
    TaskFormModal
  }
}
</script>

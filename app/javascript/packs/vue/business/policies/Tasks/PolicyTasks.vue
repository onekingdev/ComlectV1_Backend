<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Tasks
    .policy-actions
      TaskFormModal(:defaults="taskDefaults" v-if="!currentUserBasic && !policy.archived" @saved="$emit('saved')")
        button.btn.btn-dark Add Task
    .policy-details__body
      table.table
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
      EmptyState(v-if="!loading && !tasksSorted.length")
</template>

<script>
import Loading from '@/common/Loading/Loading'
import TaskFormModal from '@/common/TaskFormModal'
import EtaggerMixin from '@/mixins/EtaggerMixin'

export default {
  mixins: [EtaggerMixin()],
  props: {
    policy: {
      type: Object,
      required: true
    },
    currentUserBasic: {
      type: Boolean,
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
    loading() {
      return this.$store.getters.loading;
    },
    tasksComputed() {
      return this.policy.reminders || []
    },
    tasksSorted() {
      if (this.sortField) {
        const compare = (aField, bField) => {
          const [a, b] = [aField[this.sortField], bField[this.sortField]]
          return a > b ? this.sortDirection : (a < b ? (this.sortDirection * -1) : 0)
        }
        return this.tasksComputed.sort(compare)
      }
      return this.tasksComputed
    },
    taskDefaults() {
      return {
        linkable_type: 'CompliancePolicy',
        linkable_id: this.policy.id
      }
    }
  },
  components: {
    Loading,
    TaskFormModal
  },
}
</script>

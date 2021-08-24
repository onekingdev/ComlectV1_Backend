<template lang="pug">
  table.table.task_table.project-table
    thead
      tr
        th.project-table__name.project-table__name_head
          span.pointer(@click="toggleSorting('title')")
            | Name
            b-icon.ml-2(icon='chevron-expand')
        th.project-table__assignee.project-table__assignee_head Collaborators
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__left.project-table__left_head.text-right
          span.pointer(@click="toggleSorting('tasks_left', true)")
            | Tasks Left
            b-icon.ml-2(icon='chevron-expand')
        th.project-table__coast.project-table__coast_head.text-right
          span.pointer(@click="toggleSorting('cost_int', true)")
            | Cost
            b-icon.ml-2(icon='chevron-expand')
        th.project-table__status.project-table__status_head Status
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__start-date.project-table__start-date_head
          span.pointer(@click="toggleSorting('starts_on_int')")
            | Start Date
            b-icon.ml-2(icon='chevron-expand')
        th.project-table__end-date.project-table__end-date_head.text-right
          span.pointer(@click="toggleSorting('ends_on_int')")
            | End Date
            b-icon.ml-2(icon='chevron-expand')
    tbody
      tr(v-for="project in projectsSorted" :key="key(project)")
        td.project-table__name: router-link.link(:to='`${project.href}`') {{ project.title }}
        td.project-table__assignee {{ project.assignee }}
        td.project-table__left.text-right {{ project.tasks_left || '----' }}
        td.project-table__coast.text-right {{ project.cost | usdWhole }}
        td.project-table__status
          span.badge(:class="badgeClass(project)") {{ project.status | statusCorrector }}
        td.project-table__start-date {{ project.starts_on | asDate }}
        td.project-table__end-date.text-right(class="due-date" :class="{ overdue: isOverdue(project) }")
          b-icon.mr-2(v-if="isOverdue(project)" icon="exclamation-triangle-fill" variant="warning")
          span.end-date {{ project.ends_on | asDate }}
</template>

<script>
import { isOverdue, badgeClass } from '@/common/TaskHelper'

const key = project => `${project.id}${project.type ? '-p' : '-l'}`
const tasks_left = project => project.reminders.filter(r => !r.done_at).length

export default {
  props: {
    projects: {
      type: Array,
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
    key,
    isOverdue,
    badgeClass,
    toggleSorting(field, startDescending = false) {
      const initialDirection = startDescending ? -1 : 1
      this.sortDirection = this.sortField === field ? -1 * this.sortDirection : initialDirection
      this.sortField = field
    }
  },
  computed: {
    projectsSorted() {
      if (this.sortField) {
        const compare = (aField, bField) => {
          const [a, b] = [aField[this.sortField], bField[this.sortField]]
          return a > b ? this.sortDirection : (a < b ? (this.sortDirection * -1) : 0)
        }
        return this.projectsPrepared.sort(compare)
      }
      return this.projectsPrepared
    },
    projectsPrepared() {
      // unset values should be considered "less" than zeroes, and are replaced with -1
      const asSortableNonNeg = val => val ? +val.replace(/\-/g, '') : -1
      return this.projects.map(p => ({
        ...p,
        href: this.$store.getters.url('URL_PROJECT_SHOW', p.id),
        tasks_left: tasks_left(p),
        cost_int: asSortableNonNeg(p.cost),
        starts_on_int: asSortableNonNeg(p.starts_on),
        ends_on_int: asSortableNonNeg(p.ends_on),
      }))
    }
  },
  filters: {
    statusCorrector: function (value) {
      if (value === 'inprogress') value = 'In Progress'
      return value.replace(/[A-Z]/g, ' $&')
    }
  },
}
</script>

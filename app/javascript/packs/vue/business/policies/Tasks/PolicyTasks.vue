<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Tasks
    .policy-actions
      //button.btn.btn.btn-default.mr-3 Download
      PolicyTaskModal(:tasks="tasksComputed" :linkableId="policy.id" linkableType="CompliancePolicy" @saved="savedConfirmed")
        button.btn.btn-dark Add Task
    .policy-details__body
      table.table
        thead
          tr
            th(width="45%") Task Name
              b-icon.ml-2(icon='chevron-expand')
            th Assignee
              b-icon.ml-2(icon='chevron-expand')
            th Start Date
              b-icon.ml-2(icon='chevron-expand')
            th Due Date
            th Files
            th Comments
              b-icon.ml-2(icon='chevron-expand')
            th(width="35px")
        tbody.text-dark(v-if="tasksComputed && tasksComputed.length")
          tr(v-for="task in tasksComputed" :key="task.id")
            td {{ task.body }}
            td ---
            td {{ task.created_at | asDate }}
            td {{ task.end_date | asDate }}
            td ---
            td ---
            td.actions
                b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
                  template(#button-content)
                    b-icon(icon="three-dots")
                  b-dropdown-item-button Edit
                  b-dropdown-item-button Delete
      EmptyState(v-if="!loading && !tasksComputed.length")
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import PolicyTaskModal from '@/business/tasks/modals/TaskModalCreateEdit'
  import EtaggerMixin from '@/mixins/EtaggerMixin'

  export default {
    mixins: [EtaggerMixin()],
    props: {
      policy: {
        type: Object,
        required: true
      },
    },
    components: {
      Loading,
      PolicyTaskModal
    },
    created() {
      console.log('created', this.policy)
    },
    data() {
      return {

      }
    },
    methods: {
      savedConfirmed(value){
        console.log('savedConfirmed value', value)
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      tasksComputed() {
        return this.policy.reminders || []
      },
    },
  }
</script>

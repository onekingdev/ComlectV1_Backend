<template lang="pug">
  div.d-inline-block
    div.d-inline-block(v-b-modal="modalId")
      slot

    b-modal.fade(:id="modalId" :title="taskId ? task.body : 'New task'" @show="getData")
      InputText(v-model="task.body" :errors="errors.body" placeholder="Enter the name of your task") Task Name

      label.m-t-1.form-label Link to
      ComboBox(V-model="task.link_to" :options="linkToOptions" placeholder="Select projects, annual reviews, or policies to link the task to" @input="inputChangeLinked")
      .form-text.text-muted Optional
      Errors(:errors="errors.link_to")

      label.m-t-1.form-label Assignee
      ComboBox(V-model="task.assignee" :options="assigneeOptions" placeholder="Select an assignee")
      Errors(:errors="errors.assignee")

      b-row.m-t-1(no-gutters)
        .col-sm.m-r-1
          label.form-label Start Date
          DatePicker(v-model="task.remind_at")
          Errors(:errors="errors.remind_at")
          .form-text.text-muted Optional
        .col-sm
          label.form-label Due Date
          DatePicker(v-model="task.end_date")
          Errors(:errors="errors.end_date")

      b-row.m-t-1(no-gutters)
        .col-sm
          label.form-label Repeats
          Dropdown(v-model="task.repeats" :options="repeatsOptions")
        //- Daily
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_DAILY")
          label.form-label Every
          input.form-control(type="number" min="1" max="1000" step="1" v-model="task.repeat_every")
          .form-text Day(s)
        //- Weekly
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_WEEKLY")
          label.form-label Every
          input.form-control(type="number" min="1" max="1000" step="1" v-model="task.repeat_every")
          .form-text Week(s)
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_WEEKLY")
          label.form-label Day
          Dropdown(v-model="task.repeat_on" :options="daysOfWeek")
        //- Monthly
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_MONTHLY")
          label.form-label Every
          input.form-control(type="number" min="1" max="1000" step="1" v-model="task.repeat_every")
          .form-text Month(s)
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_MONTHLY")
          label.form-label On
          Dropdown(v-model="task.on_type" :options="['Day', 'First', 'Second', 'Third', 'Fourth']")
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_MONTHLY")
          label.form-label Day
          input.form-control(v-model="task.repeat_on" v-if="task.on_type === 'Day'" type="number" min="1" max="31" step="1")
          Dropdown(v-model="task.repeat_on" v-else :options="daysOfWeek")
        //- Yearly
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_YEARLY")
          label.form-label Every
          Dropdown(v-model="task.repeat_every" :options="months")
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_YEARLY")
          label.form-label On
          Dropdown(v-model="task.on_type" :options="['Day', 'First', 'Second', 'Third', 'Fourth']")
        .col-sm.m-l-1(v-if="task.repeats === repeatsValues.REPEAT_YEARLY")
          label.form-label Day
          input.form-control(v-model="task.repeat_on" v-if="task.on_type === 'Day'" type="number" min="1" max="31" step="1")
          Dropdown(v-model="task.repeat_on" v-else :options="daysOfWeek")
      Errors(:errors="errors.repeats || errors.repeat_every || errors.repeat_on || errors.on_type")

      InputTextarea.m-t-1(v-model="task.description" :errors="errors.description") Description
      .form-text.text-muted Optional

      template(slot="modal-footer")
        .d-flex.justify-content-between(style="width: 100%")
          div
            button.btn.btn-default(v-if="null === occurenceId" @click="deleteTask(task)") Delete Task
            b-dropdown(v-else-if="taskId" variant="dark" text="Delete Task")
              b-dropdown-item(@click="deleteTask(task, true)") Delete Occurence
              b-dropdown-item(@click="deleteTask(task)") Delete Series
          div
            button.btn.link.m-r-1(@click="$bvModal.hide(modalId)") Cancel
            button.btn.btn-default.m-r-1(v-if="taskId && !task.done_at" @click="toggleDone(task)") Mark as Complete
            button.btn.btn-default.m-r-1(v-if="taskId && task.done_at" @click="toggleDone(task)") Mark as Incomplete
            button.btn.btn-dark(v-if="!taskId" @click="submit()") Create
            button.btn.btn-dark(v-else-if="null === occurenceId" @click="submit()") Save
            b-dropdown(v-else variant="dark" text="Save")
              b-dropdown-item(@click="submit(true)") Save Occurence
              b-dropdown-item(@click="submit()") Save Series
</template>

<script>
  import { mapGetters, mapActions } from "vuex"
  import { DateTime } from 'luxon'
  import { splitReminderOccurenceId } from '@/common/TaskHelper'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = (id, label) => ({ id, label })
  const index = (text, i) => ({ text, value: 1 + i })

  const initialTask = defaults => ({
    body: null,
    link_to: null,
    assignee: null,
    remind_at: null,
    end_date: null,
    repeats: REPEAT_NONE,
    repeat_every: null,
    repeat_on: null,
    on_type: null,
    description: "",
    ...(defaults || {})
  })

  const REPEAT_NONE = null,
    REPEAT_DAILY = 'Daily',
    REPEAT_WEEKLY = 'Weekly',
    REPEAT_MONTHLY = 'Monthly',
    REPEAT_YEARLY = 'Yearly',
    REPEAT_LABELS = {
      [REPEAT_NONE]: 'Does not repeat',
      [REPEAT_DAILY]: 'Daily',
      [REPEAT_WEEKLY]: 'Weekly',
      [REPEAT_MONTHLY]: 'Monthly',
      [REPEAT_YEARLY]: 'Yearly',
    },
    REPEAT_OPTIONS = [REPEAT_NONE, REPEAT_DAILY, REPEAT_WEEKLY, REPEAT_MONTHLY, REPEAT_YEARLY]

  export default {
    props: {
      id: String,
      taskId: Number,
      occurenceId: Number,
      remindAt: String
    },
    data() {
      return {
        modalId: this.id || `modal_${rnd()}`,
        task: initialTask(),
        errors: [],
      }
    },
    methods: {
      ...mapActions({
        getReviews: 'annual/getReviews',
        getProjects: 'projects/getProjects'
      }),
      deleteTask(task, deleteOccurence) {
        const occurenceParams = deleteOccurence ? `?oid=${this.occurenceId}` : ''
        fetch('/api/business/reminders/' + this.taskId + occurenceParams, {
          method: 'DELETE',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        }).then(response => this.$emit('saved'))
      },
      toggleDone(task) {
        const { taskId, oid } = splitReminderOccurenceId(task.id)
        const oidParam = oid !== null ? `&oid=${oid}` : ''
        var target_state = (!(!!task.done_at)).toString()
        var src_id_params = oid !== null ? `&src_id=${this.taskId}` : ''
        fetch(`/api/business/reminders/${taskId}?done=${target_state}${oidParam}${src_id_params}`, {
          method: 'POST',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        }).then(response => this.$emit('saved'))
      },
      async submit(saveOccurence) {
        this.errors = []
        // const toId = (this.taskId) ? `/${this.taskId}` : ''
        const occurenceParams = saveOccurence ? `?oid=${this.occurenceId}&src_id=${this.taskId}` : ''

        try {
          const data = {
            ...this.task,
            // linkable_type: 'CompliancePolicy',
            // linkable_id: 145
            // linkable_type: 'LocalProject',
            // linkable_id: 7
            // linkable_type: 'AnnualReport',
            // linkable_id: 23
          }
          console.log(data)

          await this.$store.dispatch("reminders/createTask", data)
            .then(response => {
              if (response.errors) {
                this.toast('Error', `${response.status}`)
                Object.keys(response.errors)
                  .map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
              }
              if (!response.errors) {
                this.toast('Success', 'The task has been saved')
                this.$emit('saved')
                this.$bvModal.hide(this.modalId)
              }
            })
            .catch(error => {
              console.error('error', error)
              this.toast('Error', `Something wrong! ${error.message}`)
            })
        } catch (error) {
          this.toast('Error', error.message)
          console.error('catch error', error)
        }

        // fetch('/api/business/reminders' + toId + occurenceParams, {
        //   method: 'POST',
        //   headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        //   body: JSON.stringify(this.task)
        // }).then(response => {
        //   if (response.status === 422) {
        //     response.json().then(errors => {
        //       this.errors = errors
        //       Object.keys(this.errors)
        //         .map(prop => this.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
        //     })
        //   } else if (response.status === 201 || response.status === 200) {
        //     this.$emit('saved')
        //     this.toast('Success', 'The task has been saved')
        //     this.$bvModal.hide(this.modalId)
        //     this.resetTask()
        //   } else {
        //     this.toast('Error', 'Couldn\'t submit form')
        //   }
        // })
      },
      // resetTask() {
      //   if (this.taskId) {
      //     fetch(`/api/business/reminders/${this.taskId}`, {
      //       method: 'GET',
      //       headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      //     }).then(response => response.json())
      //       .then(result => Object.assign(this.task, result))
      //   } else {
      //     this.task = initialTask(this.remindAt ? { remind_at: this.remindAt } : undefined)
      //   }
      // },
      async getData () {
        try {

          this.task = { ...this.taskProp }

          // await this.$store.dispatch('filefolders/getFileFolders')

          this.$store.dispatch("getPolicies")
            .then((response) => console.log('getPolicies response mounted', response))
            .catch((err) => console.error(err));

          // this.getReviews
          this.$store.dispatch('annual/getReviews')
            .then((response) => console.log('getReviews response mounted', response))
            .catch((err) => console.error(err));

          // this.getProjects
          this.$store.dispatch('projects/getProjects')
            .then((response) => console.log('getProjects response mounted', response))
            .catch((err) => console.error(err));

          // fetch('/api/business/local_projects/', {
          //   method: 'GET',
          //   headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          //   // body: JSON.stringify(this.task)
          // }).then(response => response.json())
          //   .then((response) => {
          //     console.log('local_projects response mounted', response)
          //     this.projects = response
          //   })
          //   .catch((err) => console.error(err));

        } catch (error) {
          console.error(error)
          this.toast('Error', error.message)
        }
      },
      inputChangeLinked(value, instanceId) {
        console.log(value, instanceId)
        this.task.linkable_type = 'AnnualReport'
        this.task.linkable_id = value
      },
    },
    computed: {
      ...mapGetters({
        reviews: 'annual/reviews',
        projects: 'projects/projects',
      }),
      policies() {
        return this.$store.getters.policiesList
      },
      daysOfWeek() {
        return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map(index)
      },
      months() {
        return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map(index)
      },
      repeatsValues() {
        return {REPEAT_NONE, REPEAT_DAILY, REPEAT_WEEKLY, REPEAT_MONTHLY, REPEAT_YEARLY}
      },
      repeatsOptions: () => REPEAT_OPTIONS.map(value => ({ value, text: REPEAT_LABELS[value] })),
      // linkToOptions() {
      //   return [{...toOption('Projects'), children: ['Some project', 'Another', 'One'].map(toOption)},
      //     {...toOption('Annual Reviews'), children: ['Annual Review 2018', 'Annual Review 1337', 'Some Review'].map(toOption)},
      //     {...toOption('Policies'), children: ['Pol', 'Icy', 'Policy 3'].map(toOption)}]
      // },
      linkToOptions() {
        return [{...toOption(1, 'Projects'), children: this.projects.map(record => ({ id: record.id, label: record.title }))},
                {...toOption(2, 'Internal Reviews'), children: this.reviews.map(record => ({ id: record.id, label: record.name }))},
                {...toOption(3, 'Policies'), children: this.policies.map(record => ({ id: record.id, label: record.name }))},
              ]
      },
      assigneeOptions() {
        return ['John', 'Doe', 'Another specialist'].map(toOption)
      },
    },
    watch: {
      'task.remind_at': {
        handler: function(value, oldVal) {
          const start = DateTime.fromSQL(value), end = DateTime.fromSQL(this.task.end_date)
          if (!start.invalid && (end.invalid || (end.startOf('day') < start.startOf('day')))) {
            this.task.end_date = value
          }
        }
      }
    }
  }
</script>

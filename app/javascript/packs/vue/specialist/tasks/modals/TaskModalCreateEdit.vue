<template lang="pug">
  div.d-inline-block
    div.d-inline-block(v-b-modal="modalId")
      slot

    b-modal.fade(:id="modalId" :title="taskProp ? taskProp.body : 'New task'" :size="taskProp ? 'xl' : 'md'" @show="getData")
      b-row
        div(:class="taskProp ? 'col-lg-6 pr-2' : 'col'")
          InputText(v-model="task.body" :errors="errors.body" placeholder="Enter the name of your task") Task Name

          label.m-t-1.form-label Link to
          ComboBox(V-model="task.link_to" :options="linkToOptions" placeholder="Select projects, internal reviews, or policies to link the task to" @input="inputChangeLinked")
          .form-text.text-muted Optional
          Errors(:errors="errors.link_to")

          label.m-t-1.form-label Assignee
          ComboBox(V-model="task.assignee" :options="assigneeOptions" placeholder="Select an assignee")
          Errors(:errors="errors.assignee")

          b-row.m-t-1(no-gutters)
            .col-sm.m-r-1
              label.form-label Start Date
              DatePicker(v-model="task.remind_at" :options="datepickerOptions")
              Errors(:errors="errors.remind_at")
              .form-text.text-muted Optional
            .col-sm
              label.form-label Due Date
              DatePicker(v-model="task.end_date" :options="datepickerOptions")
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

          b-row.m-t-1(v-if="task.repeats" no-gutters )
            .col-sm-6.m-r-1
              label.form-label End By Date
              DatePicker(v-model="task.end_by")
              Errors(:errors="errors.end_by")

          InputTextarea.m-t-1(v-model="task.description" :rows="8" :errors="errors.description") Description
          .form-text.text-muted Optional

        .col-lg-6.pl-2(v-if="taskProp")
          .card-body.white-card-body.messages-border.h-100.p-0
            b-tabs.special-navs-messages(content-class="m-20" class="p-t-20")
              b-tab(title="Comments" active)
                b-row
                  .col.text-center
                    .card-body.p-0
                      Messages

              b-tab(title="Files")
                b-row
                  .col
                    .card-body.p-0
                      b-form-group
                        //b-form-file(v-model='task.file' :state='Boolean(task.file)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')
                        //.mt-3 Selected file: {{ task.file ? task.file.name : '' }}
                        label
                          a.btn.btn-default Upload File
                          input(type="file" name="file" @change="onFileChanged" style="display: none")
                        Get(:documents="url" :etag="etag"): template(v-slot="{documents}"): .row.p-x-1
                          .alert.alert-info.col-md-4(v-for="document in documents" :key="document.id")
                            p {{ document.file_data.metadata.filename }}
                            p: a(:href='getDocumentUrl(document)' target="_blank") Download
            hr.m-0
            b-row
              .col
                .card-body.p-20.position-relative
                  label.form-label Comment
                  VueEditor(v-model="task.comment" :editor-toolbar="customToolbar")
                  button.btn.btn-primary.save-comment-btn(@click="sendMessage(task)") Send

      template(v-if="!taskProp" slot="modal-footer")
        .d-flex.justify-content-between(style="width: 100%")
          div
            button.btn.btn-default(v-if="null === occurenceId" @click="deleteTask(task)") Delete Task
            b-dropdown(v-else-if="taskId" variant="dark" text="Delete Task")
              b-dropdown-item(@click="deleteTask(task, true)") Delete Occurence
              b-dropdown-item(@click="deleteTask(task)") Delete Series
          div
            button.btn.btn-link.m-r-1(@click="$bvModal.hide(modalId)") Cancel
            button.btn.btn-default.m-r-1(v-if="taskId && !task.done_at" @click="toggleDone(task)") Mark as Complete
            button.btn.btn-default.m-r-1(v-if="taskId && task.done_at" @click="toggleDone(task)") Mark as Incomplete
            button.btn.btn-dark(v-if="!taskId" @click="submit()") Create
            button.btn.btn-dark(v-else-if="null === occurenceId" @click="submit()") Save
            b-dropdown(v-else variant="dark" text="Save")
              b-dropdown-item(@click="submit(true)") Save Occurence
              b-dropdown-item(@click="submit()") Save Series

      template(v-if="task.done_at && taskProp" slot="modal-footer")
        span.mr-2
          b-icon.m-r-1.pointer(icon="check-circle-fill" class="done_task")
          b Completed on {{ task.done_at | asDate }}
        button.btn.btn-default(@click="toggleDone(task)") Reopen
      template(v-if="!task.done_at && taskProp" slot="modal-footer")
        button.btn.btn-outline-danger.mr-auto(@click="deleteTask(task)") Delete Task
        //button.btn.btn-link.ml-auto(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-default(@click="toggleDone(task)") Mark as Complete
        button.btn.btn-dark(@click="submitUpdate") Save

</template>

<script>
  import { mapGetters, mapActions } from "vuex"
  import { DateTime } from 'luxon'
  import { VueEditor } from "vue2-editor"

  import { splitReminderOccurenceId } from '@/common/TaskHelper'
  import ComboBox from '@/common/ComboBox'
  import Messages from '@/common/Messages'
  import Errors from '@/common/Errors'

  import EtaggerMixin from '@/mixins/EtaggerMixin'

  const uploadFile = async function(url, file) {
    const formData  = new FormData()
    formData.append('file', file)
    return await fetch(url, {
      method: 'POST',
      body: formData
    })
  }

  const checkArray = function (nameArray, linkableTypeName) {
    nameArray.forEach(element => {
      if (element.title === value) {
        tempTask.linkable_type = linkableTypeName
        tempTask.linkable_id = element.id
      }
    });
  }

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const today = new Date();
  const year = today.getFullYear();
  const toOption = id => ({ id, label: id })
  const index = (text, i) => ({ text, value: 1 + i })

  const initialTask = defaults => ({
    body: null,
    link_to: null,
    assignee: null,
    remind_at: null,
    end_date: null,
    end_by: null,
    year: year,
    repeats: REPEAT_NONE,
    repeat_every: null,
    repeat_on: null,
    on_type: null,
    description: "",
    comment: '',
    file: null,
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
    mixins: [EtaggerMixin()],
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      id: String,
      taskProp: {
        type: Object,
        required: false
      },
      taskId: Number,
      occurenceId: Number,
      remindAt: String
    },
    components: {
      VueEditor,
      ComboBox,
      Messages,
      Errors,
    },
    data() {
      return {
        modalId: this.id || `modal_${rnd()}`,
        task: initialTask(),
        errors: [],
        customToolbar: [
          ["bold", "italic", "underline"],
          ["blockquote"],
          [{ list: "bullet" }],
          ["link"]
        ],
      }
    },
    methods: {
      ...mapActions({
        // getReviews: 'annual/getReviews',
        getProjects: 'projects/getProjects'
      }),
      toggleDone(task) {
        const { taskId, oid } = splitReminderOccurenceId(task.id)
        const oidParam = oid !== null ? `&oid=${oid}` : ''
        const src_id_params = oid !== null ? `&src_id=${task.id}` : ''
        let target_state = (!(!!task.done_at)).toString()

        try {
          this.$store.dispatch('reminders/updateTaskStatus', { id: taskId, done: target_state, oidParam, src_id_params })
            .then(response => {
              this.toast('Success', 'The task has been saved')
              this.$emit('saved')
              this.$bvModal.hide(this.modalId)
            })
            .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
        } catch (error) {
          this.toast('Error', error.message)
          console.error(error)
        }
      },
      deleteTask(task, deleteOccurence){
        const occurenceParams = deleteOccurence ? `?oid=${this.occurenceId}` : ''
        this.$store.dispatch('reminders/deleteTask', { id: task.id, occurenceParams })
          .then(response => {
            this.toast('Success', `The task deleted!`)
            this.$emit('saved')
            this.$bvModal.hide(this.modalId)
          })
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
      },
      async submit(saveOccurence) {
        this.errors = []
        // const toId = (this.taskId) ? `/${this.taskId}` : ''
        const occurenceParams = saveOccurence ? `?oid=${this.occurenceId}&src_id=${this.taskId}` : ''

        try {
          const data = {
            ...this.task,
            occurenceParams
          }
          console.log(data)

          await this.$store.dispatch("reminders/createTask", data)
            .then(response => {
              this.toast('Success', 'The task has been saved')
              this.$emit('saved')
              this.$bvModal.hide(this.modalId)
            })
            .catch(error => {
              console.error('error', error)
              this.toast('Error', `Something wrong! ${error.message}`, true)
            })
        } catch (error) {
          this.toast('Error', error.message, true)
          console.error('catch error', error)
        }
      },

      inputChangeLinked(value, ) {
        let tempTask = {}
        checkArray(this.projects, 'LocalProject')
        // checkArray(this.policies, 'CompliancePolicy')
        // checkArray(this.reviews, 'AnnualReport')
        this.task = {
          ...this.task,
          ...tempTask,
        }
      },

      async submitUpdate(e) {
        e.preventDefault();

        this.errors = []
        const toId = (this.task.id) ? `${this.task.id}` : ''

        try {
          const data = {
            id: toId,
            task: {
              ...this.task,
            },
          }

          console.log(data)

          await this.$store.dispatch("reminders/updateTask", data)
            .then(response => {
              // if (response.errors) {
              //   this.toast('Error', `${response.status}`)
              //   Object.keys(response.errors)
              //     .map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
              //   return
              // }
              this.toast('Success', 'The task has been saved')
              this.$emit('saved')
              this.$bvModal.hide(this.modalId)
            })
            .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
        } catch (error) {
          this.toast('Error', error.message)
          console.error(error)
        }
      },
      async onFileChanged(event) {
        const file = event.target.files && event.target.files[0]
        if (file) {
          const success = (await uploadFile(this.url, file)).ok
          const message = success ? 'Document uploaded' : 'Document upload failed'
          this.toast('Document Upload', message, !success)
          this.newEtag()
        }
      },
      getDocumentUrl(document) {
        return `/uploads/${document.file_data.storage}/${document.file_data.id}`
      },
      async getData () {
        this.task = { ...this.taskProp }
        try {
          if(this.taskProp)
            this.$store.dispatch("reminders/getTaskMessagesById", { id: this.taskProp.id })

          // this.$store.dispatch("getPolicies")

          // this.$store.dispatch('annual/getReviews')

          this.$store.dispatch('projects/getProjects')

        } catch (error) {
          console.error(error)
          this.toast('Error', error.message, true)
        }
      },
      sendMessage(task) {

        const data = {
          id: task.id,
          message: {
            message: this.task.comment
          }
        }

        this.$store.dispatch("reminders/postTaskMessageById", data)
          .then((response) => console.log('postTaskMessageById response mounted', response))
          .catch((err) => console.error(err));
      }
    },
    computed: {
      ...mapGetters({
        // reviews: 'annual/reviews',
        projects: 'projects/projects',
      }),
      // policies() {
      //   return this.$store.getters.policiesList
      // },
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
      linkToOptions() {
        return [{...toOption('Projects'), children: this.projects.map(record => ({ id: record.title, label: record.title }))},
                // {...toOption('Internal Reviews'), children: this.reviews.map(record => ({ id: record.name, label: record.name }))},
                // {...toOption('Policies'), children: this.policies.map(record => ({ id: record.name, label: record.name }))},
              ]
      },
      assigneeOptions() {
        return ['John', 'Doe', 'Another specialist'].map(toOption)
      },

      url() {
        return `/api/business/reminders/${(this.taskProp.id) ? `${this.taskProp.id}` : ''}/documents`
        // return `/api/business/reminders/${(this.taskProp.id) ? `/${this.taskProp.id}` : ''}/messages`
      },
      datepickerOptions() {
        return {
          // min: new Date
        }
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

<style scoped>

</style>

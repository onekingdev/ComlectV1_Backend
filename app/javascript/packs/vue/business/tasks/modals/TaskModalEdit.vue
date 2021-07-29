<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Do Task A" size="xl" @shown="getData")
      b-row
        .col-lg-6.pr-2
          b-row.m-b-10
            .col-12
              label.form-label Task Name
              input.form-control(v-model="task.body" type="text" placeholder="Enter the name of your task" ref="input")
              Errors(:errors="errors.body")
          b-row.m-b-10
            .col-12
              label.form-label Link To
              //input.form-control(v-model="task.linkTo" type="text" placeholder="Link to")
              ComboBox(v-model="task.link_to" :options="linkToOptions" placeholder="Select projects, internal reviews, or policies to link the task to")
              small(class="form-text text-muted") Optional
              Errors(:errors="errors.link_to")
          b-row
            .col-12.m-b-10
              label.form-label Assegnee
              //b-form-select(v-model="task.selected" :options="task.options")
              ComboBox(v-model="task.assignee" :options="assigneeOptions" placeholder="Select an assignee")
              small(class="form-text text-muted") Optional
              Errors(:errors="errors.assignee")
          b-row.mb-0
            .col-6
              label.form-label Start Date
              DatePicker(v-model="task.remind_at" :options="datepickerOptions")
              Errors(:errors="errors.remind_at")
            .col-6
              label.form-label Due Date
              DatePicker(v-model="task.end_date" :options="datepickerOptions")
              Errors(:errors="errors.end_date")
          b-row.m-b-10(no-gutters)
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
              .form-text Months(s)
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
          b-row.m-b-10
            .col
              label.form-label Description
              textarea.form-control(v-model="task.description" rows="6")
              small(class="form-text text-muted") Optional
              Errors(:errors="errors.description")
        .col-lg-6.pl-2
          .card-body.white-card-body.reviews__card.p-0
            b-tabs(content-class="mt-2" class="pt-3")
              b-tab(title="Comments" active)
                b-row
                  .col.text-center
                    .card-body.p-3
                      h4 No Comments to Display
                      p Type in the comment box below to get started
              b-tab(title="Files")
                b-row
                  .col
                    .card-body.p-3
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
            hr
            b-row
              .col
                .card-body.p-3.position-relative
                  label.form-label Comment
                  VueEditor(v-model="task.comment" :editor-toolbar="customToolbar")
                  button.btn.btn-primary.save-comment-btn(@click="sendMessage") Send

      template(v-if="task.done_at" slot="modal-footer")
        span.mr-2
          b-icon.m-r-1.pointer(icon="check-circle-fill" class="done_task")
          b Completed on {{ task.done_at | dateToHuman }}
        button.btn.btn-default(@click="toggleDone(task)") Reopen
      template(v-if="!task.done_at" slot="modal-footer")
        button.btn.btn-outline-danger.mr-auto(@click="deleteTask(task)") Delete Task
        //button.btn.ml-auto(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-default(@click="toggleDone(task)") Mark as Complete
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import { mapGetters, mapActions } from "vuex"
  import ComboBox from '@/common/ComboBox'
  import Errors from '@/common/Errors'
  import { VueEditor } from "vue2-editor"
  import { DateTime } from 'luxon'
  import { splitReminderOccurenceId } from '@/common/TaskHelper'

  import EtaggerMixin from '@/mixins/EtaggerMixin'

  const uploadFile = async function(url, file) {
    const formData  = new FormData()
    formData.append('file', file)
    return await fetch(url, {
      method: 'POST',
      body: formData
    })
  }

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  var today = new Date();
  var year = today.getFullYear();
  const toOption = id => ({ id, label: id })

  const initialTask = defaults => ({
    body: null,
    link_to: null,
    assignee: null,
    year: year,
    remind_at: null,
    end_date: null,
    description: '',
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
        required: true
      },
      taskId: Number,
      occurenceId: Number,
      remindAt: String
    },
    components: {
      ComboBox,
      Errors,
      VueEditor,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        task: initialTask(),
        errors: [],
        reviews: [],
        projects: [],
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
        // updateAnnual: 'annual/updateReview',
        // getCurrentReviewReview: 'annual/getCurrentReview'
      }),
      toggleDone(task) {
        const { taskId, oid } = splitReminderOccurenceId(task.id)
        const oidParam = oid !== null ? `&oid=${oid}` : ''
        let target_state = (!(!!task.done_at)).toString()

        try {
          this.$store.dispatch('reminders/updateTaskStatus', { id: taskId, done: target_state })
            .then(response => this.toast('Success', `Updated!`))
            .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
        } catch (error) {
          this.toast('Error', error.message)
          console.error(error)
        }
      },
      deleteTask() {
        try {
          this.$store.dispatch('reminders/deleteTask', { id: this.task.id })
            .then(response => {{
              this.toast('Success', `The Task has been deleted!`)
              this.$bvModal.hide(this.modalId)
            }})
            .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
        } catch (error) {
          this.toast('Error', error.message)
          console.error(error)
        }

        // const occurenceParams = deleteOccurence ? `?oid=${this.occurenceId}` : ''
        // fetch('/api/business/reminders/' + this.taskId + occurenceParams, {
        //   method: 'DELETE',
        //   headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        // }).then(response => this.$emit('saved'))
      },
      submit(e) {
        e.preventDefault();

        this.errors = []
        const toId = (this.task.id) ? `${this.task.id}` : ''

        try {
          const data = {
            id: toId,
            task: {
              ...this.task,
              // linkable_type: 'Exams',
              // linkable_id: 28
            },
          }

          console.log(data)

          this.$store.dispatch("reminders/updateTask", data)
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

        // await this.$store.dispatch("reminders/updateTask", data)
        //   .then((response) => {
        //     console.log('updateTask response', response)
        //
        //     this.$emit('saved')
        //     this.toast('Success', 'The task has been saved')
        //     this.$bvModal.hide(this.modalId)
        //   })
        //   .catch((err) => console.error(err));

        // fetch('/api/business/reminders' + toId, {
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
        //     // this.resetTask()
        //   } else {
        //     this.toast('Error', 'Couldn\'t submit form')
        //   }
        // })

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
      // }
      async getData () {
        try {

          this.task = { ...this.taskProp }

          // await this.$store.dispatch('filefolders/getFileFolders')

          if (this.taskId)
            this.$store.dispatch("reminders/getTaskMessagesById", { id: this.taskId })
              .then((response) => console.log('getTaskMessagesById response mounted', response))
              .catch((err) => console.error(err));

          this.$store.dispatch("getPolicies")
            .then((response) => console.log('getPolicies response mounted', response))
            .catch((err) => console.error(err));

          this.$store.dispatch('annual/getReviews')
            .then((response) => console.log('getReviews response mounted', response))
            .catch((err) => console.error(err));

          fetch('/api/business/local_projects/', {
            method: 'GET',
            headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
            // body: JSON.stringify(this.task)
          }).then(response => response.json())
            .then((response) => {
              console.log('local_projects response mounted', response)
              this.projects = response
            })
            .catch((err) => console.error(err));

        } catch (error) {
          console.error(error)
          this.toast('Error', error.message)
        }
      },
      sendMessage() {
        console.log(this.task)
        const data = {
          id: this.taskId,
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
        // review: 'annual/currentReview'
      }),
      // reviewsOptions () {
      //   const revOpt = this.reviews.map(review => {
      //     return { value: review.id, text: review.name }
      //   })
      //   return revOpt ? revOpt : []
      // },
      policies() {
        return this.$store.getters.policiesList
      },
      repeatsValues() {
        return {REPEAT_NONE, REPEAT_DAILY, REPEAT_WEEKLY, REPEAT_MONTHLY, REPEAT_YEARLY}
      },
      repeatsOptions: () => REPEAT_OPTIONS.map(value => ({ value, text: REPEAT_LABELS[value] })),
      linkToOptions() {
        return [{...toOption('Projects'), children: this.projects.map(record => record.title).map(toOption)},
          {...toOption('Internal Reviews'), children: this.reviews.map(record => record.name).map(toOption)},
          {...toOption('Policies'), children: this.policies.map(record => record.name).map(toOption) }]
      },
      assigneeOptions() {
        return ['John', 'Doe', 'Another specialist'].map(toOption)
      },
      url() {
        // return `/api/business/reminders/${(this.taskId) ? `/${this.taskId}` : ''}/documents`
        return `/api/business/reminders/${(this.taskId) ? `/${this.taskId}` : ''}/messages`
      },
      datepickerOptions() {
        return {
          min: new Date
        }
      },
    },
    mounted() {

    },
    filters: {
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('MM/dd/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
    }
  }
</script>

<style scoped>
  .save-comment-btn {
    position: absolute;
    right: 2rem;
    bottom: 2rem;
  }
</style>

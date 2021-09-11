<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="taskId ? task.body : 'New task'" :size="taskId ? 'xl' : 'md'" @show="resetTask")
      b-row
        div(:class="taskId ? 'col-lg-6 pr-2' : 'col'")
          InputText(v-model="task.body" :errors="errors.body") Task Name

          Get(v-if="isBusiness" v-bind="optionsToFetch"): template(v-slot="{projects,reviews,policies,exams}")
            label.m-t-1.form-label Link to
            ComboBox(:value="linkToValue" @input="inputLinkTo" :options="linkToOptions(projects, reviews, policies, exams)" placeholder="Select projects, internal reviews, or policies to link the task to" :tree-props="{ disableBranchNodes: true }")
            .form-text.text-muted Optional
            Errors(:errors="errors.linkable_type || errors.linkable_id")

            label.m-t-1.form-label Assignee
            ComboBox(v-model="task.assignee" :options="assigneeOptions" placeholder="Select an assignee")
            .form-text.text-muted Optional
            Errors(:errors="errors.assignee")

          b-row.m-t-1(no-gutters)
            .col-sm.m-r-1
              label.form-label.required Start Date
              DatePicker(v-model="task.remind_at" :options="datepickerOptions")
              Errors(:errors="errors.remind_at")
            .col-sm
              label.form-label.required Due Date
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

          b-row(v-if="task.repeats" no-gutters)
            .col-sm-6.m-r-1
              label.form-label End By Date
              DatePicker(v-model="task.end_by")
              Errors(:errors="errors.end_by")

          InputTextarea.m-t-1(v-model="task.description" :rows="taskId ? 7 : 3" :errors="errors.description") Description
          .form-text.text-muted Optional

        .col-lg-6.pl-2(v-if="taskId")
          .card-body.white-card-body.messages-border.h-100.p-0
            b-tabs.special-navs-messages(content-class="m-20" class="p-0")
              b-tab(title="Comments" ref="comments" active)
                b-row
                  .col.text-center
                    Get(:messages="`/api/reminders/${taskId}/messages`" :etag="etagMessages"): template(v-slot="{ messages }"): .card-body.p-0
                      Messages(:messages="messages" ref="Messages" @created="scrollMessages")
              b-tab(title="Files")
                //- @todo restrict deletion for specialist/by condition
                b-row
                  .col
                    .card-body.p-0
                      b-form-group
                        label
                          a.btn.btn-default Upload File
                          input(type="file" name="file" style="display: none")
                        .row
                          .col-md-12.m-b-1
                            .file-card
                              div
                                b-icon.file-card__icon(icon="file-earmark-text-fill")
                              .ml-0.mr-auto
                                p.file-card__name Document.pdf
                                a.file-card__link.link(href="#" target="_blank") Download
                              .ml-auto.my-auto.align-self-start.actions
                                b-dropdown(size="sm" class="m-0 p-0" right)
                                  template(#button-content)
                                    b-icon(icon="three-dots")
                                  b-dropdown-item.delete Delete
            hr.m-0
            b-row
              .col
                .card-body.p-20.position-relative
                  label.form-label Comment
                  Tiptap(v-model="message.message")
                  Errors(:errors="messageErrors.message")
                  Post(:action="`/api/reminders/${taskId}/messages`" :model="{ message }" @errors="messageErrors = $event" @saved="messageSaved")
                    button.btn.btn-primary.save-comment-btn Send

      template(v-if="!taskId" slot="modal-footer")
        .d-flex.justify-content-between(style="width: 100%")
          div
            button.btn.btn-link.m-r-1(@click="$bvModal.hide(modalId)") Cancel
            button.btn.btn-dark(@click="submit()") Save

      template(v-if="task.done_at && taskId" slot="modal-footer")
        span.mr-2
          b-icon.m-r-1.pointer(icon="check-circle-fill" class="done_task")
          b Completed on {{ task.done_at | asDate }}
        button.btn.btn-default(@click="toggleDone(task)") Reopen

      template(v-else-if="taskId" slot="modal-footer")
        TaskDeleteConfirmModal.mr-auto(v-if="null === occurenceId" :inline="false" @deleteConfirmed="deleteTask(task)")
          button.btn.btn-outline-danger Delete Task
        b-dropdown.mr-auto(v-else-if="taskId" variant="outline-danger" text="Delete Task")
          TaskDeleteConfirmModal(:inline="false" @deleteConfirmed="deleteTask(task, true)")
            b-dropdown-item Delete Occurence
          TaskDeleteConfirmModal(:inline="false" @deleteConfirmed="deleteTask(task)")
            b-dropdown-item Delete Series
        button.btn.btn-default(@click="toggleDone(task)") Mark as Complete
        button.btn.btn-dark(v-if="!taskId" @click="submit()") Create
        button.btn.btn-dark(v-else-if="null === occurenceId" @click="submit(true)") Save
        b-dropdown.font-weight-bold(v-else variant="dark" text="Save")
          b-dropdown-item(@click="submit(true)") Save Occurence
          b-dropdown-item(@click="submit()") Save Series
</template>

<script>
import { DateTime } from 'luxon'
import { splitReminderOccurenceId } from '@/common/TaskHelper'
import Messages from '@/common/Messages'
import Tiptap from '@/common/Tiptap'
import EtaggerMixin from '@/mixins/EtaggerMixin'
import TaskDeleteConfirmModal from './TaskDeleteConfirmModal'

const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const toOption = id => ({ id, label: id })
const index = (text, i) => ({ text, value: 1 + i })

const initialTask = defaults => ({
  body: null,
  linkable_id: null,
  linkable_type: null,
  assignee: null,
  remind_at: null,
  end_date: null,
  end_by: null,
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
  mixins: [EtaggerMixin('etagMessages')],
  props: {
    id: String,
    taskId: Number,
    occurenceId: Number,
    remindAt: String,
    inline: {
      type: Boolean,
      default: true
    },
    defaults: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      modalId: this.id || `modal_${rnd()}`,
      task: initialTask(this.defaults),
      errors: [],
      message: {
        message: null
      },
      messageErrors: {},
    }
  },
  methods: {
    messageSaved() {
      this.toast('Comment sent')
      this.newEtagMessages()
      this.message.message = null
      this.messageErrors = {}
      this.scrollMessages()
    },
    scrollMessages() {
      this.$nextTick(() => {
        const messagesContainer = this.$refs.Messages.$refs.MessagesContainer
        setTimeout(() => messagesContainer.scrollTop = messagesContainer.scrollHeight, 500)
      })
    },
    linkToOptions(projects, reviews, policies, exams) {
      const mapLinkProperty = (property, type) => ({ [property]: label, id }) => ({ id: `${type}|${id}`, label }),
        optionsBranch = (label, items, type, property) => ({ ...toOption(label), children: items.map(mapLinkProperty(property, type)) })
      return [
        optionsBranch('Projects', projects || [], 'LocalProject', 'title'),
        optionsBranch('Internal Reviews', reviews || [], 'AnnualReport', 'name'),
        optionsBranch('Policies', policies || [], 'CompliancePolicy', 'name'),
        optionsBranch('Exams', exams || [], 'Exam', 'name'),
      ]
    },
    inputLinkTo(value) {
      const [type, id] = value.split('|')
      this.task.linkable_type = type
      this.task.linkable_id = id
    },
    deleteTask(task, deleteOccurence) {
      const occurenceParams = deleteOccurence ? `?oid=${this.occurenceId}` : ''
      fetch('/api/reminders/' + this.taskId + occurenceParams, {
        method: 'DELETE',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      }).then(response => {
        this.$emit('saved')
        this.$router.push('/business')
      })
    },
    toggleDone(task) {
      const { taskId, oid } = splitReminderOccurenceId(task.id)
      const oidParam = oid !== null ? `&oid=${oid}` : ''
      var target_state = (!(!!task.done_at)).toString()
      var src_id_params = oid !== null ? `&src_id=${this.taskId}` : ''
      fetch(`/api/reminders/${taskId}?done=${target_state}${oidParam}${src_id_params}`, {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      }).then(response => {
        this.$emit('saved')
        this.toast('Task saved')
        this.$bvModal.hide(this.modalId)
      })
    },
    submit(saveOccurence) {
      this.errors = []
      const toId = (!saveOccurence && this.taskId) ? `/${this.taskId}` : ''
      const occurenceParams = saveOccurence ? `?oid=${this.occurenceId}&src_id=${this.taskId}` : ''
      fetch('/api/reminders' + toId + occurenceParams, {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: JSON.stringify(this.task)
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => this.errors = errors.errors)
        } else if (response.status === 201 || response.status === 200) {
          this.$emit('saved')
          this.toast('Success', 'The task has been saved')
          this.$bvModal.hide(this.modalId)
          this.resetTask()
        } else {
          this.toast('Error', 'Couldn\'t submit form')
        }
      })
    },
    resetTask() {
      if (this.taskId) {
        fetch(`/api/reminders/${this.taskId}`, {
          method: 'GET',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        }).then(response => response.json())
          .then(result => Object.assign(this.task, result))
      } else {
        const withRemindAt = this.remindAt ? { remind_at: this.remindAt } : {}
        this.task = initialTask({ ...this.defaults, ...withRemindAt })
      }
    }
  },
  computed: {
    linkToValue() {
      return this.task.linkable_type && this.task.linkable_id ? `${this.task.linkable_type}|${this.task.linkable_id}` : null
    },
    optionsToFetch() {
      return this.isBusiness
        ? {
            projects: '/api/local_projects',
            reviews: '/api/business/annual_reports',
            policies: '/api/business/compliance_policies',
            exams: '/api/business/exams'
          }
        : {}
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
    isBusiness() {
      return 'business' === this.$store.getters.userType
    },
    assigneeOptions() {
      return ['John', 'Doe', 'Another specialist'].map(toOption)
    },
    datepickerOptions() {
      return {
        min: new Date().toISOString()
      }
    },
    editorToolbar() {
      return [["bold", "italic", "underline"], ["blockquote"], [{ list: "bullet" }], ["link"]]
    }
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
  },
  components: {
    Messages,
    Tiptap,
    TaskDeleteConfirmModal,
  }
}
</script>

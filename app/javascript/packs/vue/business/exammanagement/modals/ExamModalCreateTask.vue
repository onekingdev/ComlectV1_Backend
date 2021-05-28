<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Do Task A" size="xl" @shown="onShown")
      b-row
        .col-lg-6.pr-2
          b-row.m-b-2
            .col-12
              label.form-label Task Name
              input.form-control(v-model="task.body" type="text" placeholder="Enter the name of your task" ref="input")
              Errors(:errors="errors.body")
          b-row.m-b-2
            .col-12
              label.form-label Link To
              <!--input.form-control(v-model="task.linkTo" type="text" placeholder="Link to")-->
              ComboBox(v-model="task.link_to" :options="linkToOptions" placeholder="Select projects, annual reviews, or policies to link the task to")
              small(class="form-text text-muted") Optional
              Errors(:errors="errors.link_to")
          b-row
            .col-12.m-b-2
              label.form-label Assegnee
              <!--b-form-select(v-model="task.selected" :options="task.options")-->
              ComboBox(v-model="task.assignee" :options="assigneeOptions" placeholder="Select an assignee")
              small(class="form-text text-muted") Optional
              Errors(:errors="errors.assignee")
          b-row.m-b-2
            .col-6
              label.form-label Start Date
              DatePicker(v-model="task.remind_at" :options="datepickerOptions")
              Errors(:errors="errors.remind_at")
            .col-6
              label.form-label Due Date
              DatePicker(v-model="task.end_date" :options="datepickerOptions")
              Errors(:errors="errors.end_date")
          b-row.m-b-2
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
                        <!--b-form-file(v-model='task.file' :state='Boolean(task.file)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')-->
                        <!--.mt-3 Selected file: {{ task.file ? task.file.name : '' }}-->
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
                  button.btn.btn-secondary.save-comment-btn Send

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-secondary(@click="submit") Mark as Complite
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import { mapGetters } from "vuex"
  import ComboBox from '@/common/ComboBox'
  import Errors from '@/common/Errors'
  import { VueEditor } from "vue2-editor"

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

  // const initialTask = defaults => ({
  //   body: null,
  //   link_to: null,
  //   assignee: null,
  //   year: year,
  //   remind_at: null,
  //   end_date: null,
  //   description: '',
  //   comment: '',
  //   file: null,
  //   ...(defaults || {})
  // })

  export default {
    mixins: [EtaggerMixin()],
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      // reviews: {
      //   type: Array,
      //   required: false,
      //   default: () => []
      // }
    },
    components: {
      ComboBox,
      Errors,
      VueEditor,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        task: {
          body: null,
          link_to: null,
          assignee: null,
          year: year,
          remind_at: null,
          end_date: null,
          description: '',
          comment: '',
          file: null,
          // selected: null,
          // options: [
          //   { value: null, text: 'Select assegnee' },
          //   { value: 'a', text: 'This is First option' },
          //   { value: 'b', text: 'Selected Option' },
          //   { value: { C: '3PO' }, text: 'This is an option with object value' },
          //   { value: 'd', text: 'This one is disabled', disabled: true }
          // ],
        },
        customToolbar: [
          ["bold", "italic", "underline"],
          ["blockquote"],
          [{ list: "bullet" }],
          ["link"]
        ],
        projects: [],
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();

        this.errors = []
        const toId = (this.taskId) ? `/${this.taskId}` : ''
        // console.log('this.task', this.task)
        // console.log('toId', toId)
        fetch('/api/business/reminders' + toId, {
          method: 'POST',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          body: JSON.stringify(this.task)
        }).then(response => {
          if (response.status === 422) {
            response.json().then(errors => {
              this.errors = errors
              Object.keys(this.errors)
                .map(prop => this.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
            })
          } else if (response.status === 201 || response.status === 200) {
            this.$emit('saved')
            this.toast('Success', 'The task has been saved')
            this.$bvModal.hide(this.modalId)
            // this.resetTask()
          } else {
            this.toast('Error', 'Couldn\'t submit form')
          }
        })

        // try {
        //   const response = await this.$store.dispatch('annual/createReview', this.annual_review)
        //   if (response.errors) {
        //     this.makeToast('Error', `${response.status}`)
        //     Object.keys(response.errors)
        //       .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
        //     return
        //   }
        //   this.makeToast('Success', `Annual Review Successfully created!`)
        //   this.$emit('saved')
        //   this.$bvModal.hide(this.modalId)
        // } catch (error) {
        //   this.makeToast('Error', error.message)
        // }
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
      onShown () {
        // console.log('catch')
        this.getData()
      },
      getData() {
        this.$store.dispatch("getPolicies")
          .then((response) => {
            // console.log('response mounted', response)
          })
          .catch((err) => console.error(err));

        this.$store.dispatch('annual/getReviews')
          .then((response) => {
            // console.log('response mounted', response)
          })
          .catch((err) => console.error(err));

        fetch('/api/business/local_projects/', {
          method: 'GET',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          // body: JSON.stringify(this.task)
        }).then(response => response.json())
          .then((response) => {
            // console.log('response mounted', response)
            this.projects = response
          })
          .catch((err) => console.error(err));
      }
    },
    computed: {
      // reviewsOptions () {
      //   const revOpt = this.reviews.map(review => {
      //     return { value: review.id, text: review.name }
      //   })
      //   return revOpt ? revOpt : []
      // },
      ...mapGetters({
        reviews: 'annual/reviews'
      }),
      policies() {
        return this.$store.getters.policiesList
      },
      linkToOptions() {
        return [{...toOption('Projects'), children: this.projects.map(record => record.title).map(toOption)},
          {...toOption('Annual Reviews'), children: this.reviews.map(record => record.name).map(toOption)},
          {...toOption('Policies'), children: this.policies.map(record => record.name).map(toOption) }]
      },
      assigneeOptions() {
        return ['John', 'Doe', 'Another specialist'].map(toOption)
      },
      url() {
        return `/api/business/annual_reviews/${27}/documents`
      },
      datepickerOptions() {
        return {
          min: new Date
        }
      },
    },
    // mounted() {
    //
    // },
  }
</script>

<style scoped>
  .save-comment-btn {
    position: absolute;
    right: 2rem;
    bottom: 2rem;
  }
</style>

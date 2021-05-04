<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Do Task A" size="xl")
      .row
        .col-lg-6.pr-2
          .row.m-b-2
            .col-12
              label.form-label Task Name
              input.form-control(v-model="task.name" type="text" placeholder="Enter the name of your task" ref="input")
          .row.m-b-2
            .col-12
              label.form-label Link To
              input.form-control(v-model="task.linkTo" type="text" placeholder="Link to")
              small(class="form-text text-muted") Optional
          .row(v-if="reviewsOptions && reviewsOptions.length")
            .col-12.m-b-2
              label.form-label Assegnee
              b-form-select(v-model="taskSelected" :options="taskOptions")
          .row.m-b-2
            .col-6
              label.form-label Start Date
              DatePicker(v-model="task.review_start")
              small(class="form-text text-muted") Optional
            .col-6
              label.form-label Due Date
              DatePicker(v-model="task.review_end")
          .row.m-b-2
            .col
              label.form-label Description
              textarea.form-control(v-model="task.description" rows="6")
              small(class="form-text text-muted") Optional
        .col-lg-6.pl-2
          .card-body.white-card-body.reviews__card.p-0
            b-tabs(content-class="mt-2" class="pt-3")
              b-tab(title="Comments" active)
                .row
                  .col.text-center
                    .card-body.p-3
                      h4 No Comments to Display
                      p Type in the comment box below to get started
              b-tab(title="Files")
                .row
                  .col
                    .card-body.p-3
                      b-form-group
                        b-form-file(v-model='task.file' :state='Boolean(task.file)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')
                        .mt-3 Selected file: {{ task.file ? task.file.name : '' }}
            hr
            .row
              .col
                .card-body.p-3.position-relative
                  label.form-label Comment
                  VueEditor(v-model="task.comment" :editor-toolbar="customToolbar")
                  button.btn.btn-secondary.save-comment-btn Send

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Mark as Complite
        button.btn.btn-secondary(@click="submit") Save
</template>

<script>
  import { VueEditor } from "vue2-editor"

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  var today = new Date();
  var year = today.getFullYear();

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      reviews: {
        type: Object,
        required: false,
        default: []
      },
    },
    components: {
      VueEditor,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        task: {
          name: '',
          linkTo: '',
          year: year,
          review_start: '',
          review_end: '',
          description: '',
          comment: '',
          file: null,
        },
        taskSelected: null,
        tasksOptions: [
          { value: null, text: 'Select assegnee' },
          { value: 'a', text: 'This is First option' },
          { value: 'b', text: 'Selected Option' },
          { value: { C: '3PO' }, text: 'This is an option with object value' },
          { value: 'd', text: 'This one is disabled', disabled: true }
        ],
        customToolbar: [
          ["bold", "italic", "underline"],
          ["blockquote"],
          [{ list: "bullet" }],
          ["link"]
        ],
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();

        if (!this.annual_review.name || !this.annual_review.review_start || !this.annual_review.review_end) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        try {
          const response = await this.$store.dispatch('annual/createReview', this.annual_review)
          if (response.errors) {
            this.makeToast('Error', `${response.status}`)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            return
          }
          this.makeToast('Success', `Annual Review Successfully created!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
    computed: {
      reviewsOptions () {
        const revOpt = this.reviews.map(review => {
          return { value: review.id, text: review.name }
        })
        return revOpt ? revOpt : []
      }
    },
  }
</script>

<style scoped>
  .save-comment-btn {
    position: absolute;
    right: 2rem;
    bottom: 2rem;
  }
</style>

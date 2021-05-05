<template lang="pug">
  div.review
    .card-body.white-card-body
      .container-fluid
        .row
          .col-md-12.p-t-1.d-flex.justify-content-between
            div
              h3 Internal Review&nbsp;
                span.separator /&nbsp;
                b {{ review ? review.year : '' }} {{ review ? review.name : '' }}
              h2: b {{ review ? review.year : '' }} {{ review ? review.name : '' }}
            div
              button.btn.btn-default.mr-3 Download
              button.btn.btn-dark.mr-3 Save and Exit
              button.btn.btn__close
                b-icon(icon="x")
    .reviews__tabs
      b-tabs(content-class="mt-0")
        b-tab(title="Detail" active)
          .container-fluid(v-if="review")
            .row
              .col-md-3
                ReviewsList(
                  :annual-id="annualId"
                  :reviews-categories="review.review_categories"
                  :general="true"
                )
              .col-md-9.position-relative
                .annual-actions
                  b-dropdown.bg-white(text='Actions', variant="secondary", right)
                    b-dropdown-item Duplicate
                    b-dropdown-item.delete Delete all categories
                .card-body.white-card-body.reviews__card.p-xl-5
                  .reviews__card--internal.p-b-1
                    h3
                      | General
                  .reviews__card--internal.p-y-1
                    .row
                      .col-md-12
                        h4
                          b Review Period
                        p For annual reviews, this time period typically spans a calendar or fiscal year and wil be referred to hereafter as "the Review Period
                    .row.m-b-2
                      .col-6
                        label.form-label Start Date
                        DatePicker(v-model="review.review_start")
                      .col-6
                        label.form-label End Date
                        DatePicker(v-model="review.review_end")
                  .reviews__card--internal.p-y-1
                    .row
                      .col-md-12.m-b-2
                        h4
                          b Material Business Changes
                        p List any changes to your business processes, key vendors, and/or key employees during the Review Period
                      .col-12.m-b-2
                        VueEditor(v-model="review.material_business_changes" :editor-toolbar="customToolbar")
                        .invalid-feedback.d-block(v-if="errors.material_business_changes") {{ errors.material_business_changes }}
                  .reviews__card--internal.p-y-1
                    .row
                      .col-md-12
                        h4
                          b Material Regulatory Changes
                        p List any regulatory changes that impacted you during the Review Period and how the business responded.
                    .row.m-b-2
                      .col-6
                        label.form-label Change
                        textarea.form-control(v-model="review.regulatory_changes[0].change" placeholder="Describe the change")
                        .invalid-feedback.d-block(v-if="errors.regulatory_changes") {{ errors.regulatory_changes.change }}
                      .col-6
                        label.form-label Response
                        textarea.form-control(v-model="review.regulatory_changes[1].change" placeholder="Describe the response")
                        .invalid-feedback.d-block(v-if="errors.regulatory_changes") {{ errors.regulatory_changes.change }}
                  .reviews__card--internal.p-y-1
                    .row
                      .col-md-12
                        h4 Key Employees Interviewed
                        p Regulators interview emploees to uncover potential discrepancies in a firm's policies and procedures and their day-to-day practicies. It's important to interview those employees responsible for certain key tasks or have access to sensitive client in order to hear about their day-to-day activities in their own.words. Not sure what to ask? Consider&nbsp;
                          a.link(href="#") hiring one of our compilance specialists&nbsp;
                          | to conduct mock interviews for you to see and learn how to do it on your own!
                    .row.m-b-2
                      .col-md-12
                        b-form
                          .row(v-if="review.annual_review_employees && review.annual_review_employees.length")
                            .col-4
                              label Employee Name
                            .col-4.px-0
                              label Title/Role
                            .col-4
                              label Department
                          template(v-for="(annualReviewEmployee, annualReviewEmployeeIndex) in review.annual_review_employees")
                            .row(v-for="" :key="`${annualReviewEmployeeIndex}`")
                              .col-4
                                b-input-group.m-b-1
                                  b-form-input.mb-2.mr-sm-2.mb-sm-0(v-model="annualReviewEmployee.name" placeholder='Enter Name')
                              .col-4.px-0
                                b-input-group.m-b-1
                                  b-form-input.mb-2.mr-sm-2.mb-sm-0(v-model="annualReviewEmployee.title"  placeholder='Enter Title')
                              .col-4
                                b-input-group.m-b-1
                                  b-form-input.mb-2.mr-sm-2.mb-sm-0(v-model="annualReviewEmployee.department"  placeholder='Enter Department of the organization')
                                  b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                                    template(#button-content)
                                      b-icon(icon="three-dots")
                                    b-dropdown-item Duplicate Entry
                                    b-dropdown-item.delete(@click="deleteEntry(annualReviewEmployeeIndex)") Delete Entry
                          b-input-group
                            b-button(variant='primary' class="btn-default" @click="addEntry")
                              b-icon.mr-2(icon='plus-circle-fill')
                              | Add Entry
                  .d-flex.justify-content-end.p-y-1
                    button.btn.btn-default.m-r-1(@click="saveGeneral") Save
                    AnnualModalComplite(@compliteConfirmed="markComplete", :inline="false")
                      button.btn.btn-dark Mark Complete
        b-tab(title="Tasks")
          PageTasks
        b-tab(title="Documents")
          div Documents
        b-tab(title="Activity")
          div Activity
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import ReviewsList from "./components/ReviewsList"
import AnnualModalComplite from './modals/AnnualModalComplite'
import PageTasks from './PageTasks'

export default {
  props: ['annualId'],
  components: {
    ReviewsList,
    VueEditor,
    AnnualModalComplite,
    PageTasks
  },
  data () {
    return {
      customToolbar: [
        ["bold", "italic", "underline"],
        ["blockquote"],
        [{ list: "bullet" }],
        ["link"]
      ],
      errors: {}
    }
  },
  computed: {
    ...mapGetters({
      review: 'annual/currentReview'
    })
  },
  async mounted () {
    try {
      await this.getCurrentReviewReview(this.annualId)
    } catch (error) {
      this.makeToast('Error', error.message)
    }
  },
  methods: {
    ...mapActions({
      updateAnnual: 'annual/updateReview',
      getCurrentReviewReview: 'annual/getCurrentReview'
    }),
    async saveGeneral () {
      this.errors = {}

      const review = this.review
      const data = {
        id: review.id,
        review_start: review.review_start,
        review_end: review.review_end,
        regulatory_changes_attributes: review.regulatory_changes,
        material_business_changes: review.material_business_changes,
        annual_review_employees_attributes: review.annual_review_employees
      }
      try {
        await this.updateAnnual(data)
          .then((response) => {
            console.log('response', response)
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                console.log(`${key}: ${value}`);
                this.makeToast('Error', `${key}: ${value}`)
                this.errors = Object.assign(this.errors, { [key]: value })
              }
              console.log(this.errors)
              return
            }

            if (!response.errors) {
              this.makeToast('Success', "Saved changes to annual review.")
            }
          })
          .catch((error) => console.error(error))

        await this.getCurrentReviewReview(this.annualId)

      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    async markComplete () {
      const review = this.review
      const data = {
        id: review.id,
        complete: true,
      }
      try {
        await this.updateAnnual(data)
          .then((response) => {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                console.log(`${key}: ${value}`);
                this.makeToast('Error', `${key}: ${value}`)
                this.errors = Object.assign(this.errors, { [key]: value })
              }
              return
            }

            if (!response.errors) {
              this.makeToast('Success', "Saved changes to annual review.")
            }
          })
          .catch((error) => console.error(error))
        this.makeToast('Success', "Annual review marked as complete!")
        await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    addEntry(){
      this.review.annual_review_employees.push({
        name: '',
        title: '',
        department: ''
      })
    },
    deleteEntry(i) {
      this.review.annual_review_employees.splice(i, 1);
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>

<style scoped>
  .separator {
    color: #ffc107;
  }
</style>

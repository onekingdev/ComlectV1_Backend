<template lang="pug">
  .page.review
    .page-header.bg-white
      div
        h2.page-header__breadcrumbs Internal Review&nbsp;
          span.separator /&nbsp;
          b {{ review ? review.year : '' }} {{ review ? review.name : '' }}
        h2.page-header__title: b {{ review ? review.year : '' }} {{ review ? review.name : '' }}
      .page-header__actions
        div
          button.btn.btn-default.mr-3 Download
          button.btn.btn-dark.mr-3(@click="saveGeneral(true)") Save and Exit
          AnnualModalDelete(@deleteConfirmed="deleteReview(review.id)")
            button.btn.btn__close
              b-icon(icon="x")

    b-tabs.reviews__tabs(content-class="mt-0")
      template(#tabs-end)
        b-dropdown.actions(text='Actions', variant="default", right)
          template(#button-content)
            | Actions
            b-icon.m-l-1(icon="chevron-down" font-scale="1")
          AnnualModalEdit(:review="review || {}" :inline="false")
            b-dropdown-item Edit
          AnnualModalDelete(@deleteConfirmed="deleteReview(review.id)" :inline="false")
            b-dropdown-item.delete Delete
      b-tab(title="Detail" active)
        .p-x-40(v-if="review")
          .row
            .col-md-3
              ReviewsList(
                :annual-id="annualId"
                :reviews-categories="review.review_categories"
                :general="true"
              )
            .col-md-9.m-b-40
              .card-body.white-card-body.reviews__card
                .reviews__card--internal.pt-0
                  h3
                    | General
                .reviews__card--internal
                  .row
                    .col-md-12
                      h4
                        b Review Period
                      //p For internal reviews, this time period typically spans a calendar or fiscal year and wil be referred to hereafter as "the Review Period
                  .row
                    .col-6
                      label.form-label Start Date
                      DatePicker(v-model="review.review_start")
                    .col-6
                      label.form-label End Date
                      DatePicker(v-model="review.review_end")
                .reviews__card--internal
                  .row
                    .col-md-12
                      h4
                        b Material Business Changes
                      p List any changes to your business processes, key vendors, and/or key employees during the Review Period
                    .col-12
                      VueEditor(v-model="review.material_business_changes" :editor-toolbar="customToolbar")
                      .invalid-feedback.d-block(v-if="errors.material_business_changes") {{ errors.material_business_changes }}
                .reviews__card--internal
                  .row
                    .col-md-12
                      h4
                        b Material Regulatory Changes
                      p List any regulatory changes that impacted you during the Review Period and how the business responded.
                  .row
                    .col-6
                      label.form-label Change
                      textarea.form-control(v-model="review.regulatory_changes[0].change" placeholder="Describe the change")
                      .invalid-feedback.d-block(v-if="errors.regulatory_changes") {{ errors.regulatory_changes.change }}
                    .col-6
                      label.form-label Response
                      textarea.form-control(v-model="review.regulatory_changes[1].change" placeholder="Describe the response")
                      .invalid-feedback.d-block(v-if="errors.regulatory_changes") {{ errors.regulatory_changes.change }}
                .reviews__card--internal
                  .row
                    .col-md-12
                      h4 Key Employees Interviewed
                      p Regulators interview employees to uncover potential discrepancies in a firm's policies and procedures and their day-to-day practicies. It's important to interview those employees responsible for certain key tasks or have access to sensitive client in order to hear about their day-to-day activities in their own words.
                        //a.link(href="#") hiring one of our compilance specialists&nbsp;
                        //| to conduct mock interviews for you to see and learn how to do it on your own!
                  .row
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
                                b-form-input.mb-2.mr-sm-2.mb-sm-0(v-model="annualReviewEmployee.department"  placeholder='Enter Department')
                                b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                                  template(#button-content)
                                    b-icon(icon="three-dots")
                                  //b-dropdown-item(@click="duplicateEntry(annualReviewEmployeeIndex-1)") Duplicate Entry
                                  b-dropdown-item.delete(@click="deleteEntry(annualReviewEmployeeIndex)") Delete
                        b-input-group
                          b-button(variant='default' @click="addEntry") Add Entry
                        //b-input-group
                        //  b-button(variant='primary' class="btn-none" @click="addEntry")
                        //    b-icon.mr-2(icon='plus-circle-fill')
                        //    | Add Entry
                .d-flex.justify-content-end.m-t-20
                  button.btn.btn-default.m-r-1(@click="saveGeneral") Save
                  AnnualModalComplite(@compliteConfirmed="markComplete", :inline="false")
                    button.btn.btn-dark Mark Complete
      b-tab(title="Tasks")
        PageTasks
      b-tab(title="Documents")
        PageDocuments
      b-tab(title="Activity")
        PageActivity
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import ReviewsList from "./components/ReviewsList"
import AnnualModalComplite from './modals/AnnualModalComplite'
import AnnualModalEdit from './modals/AnnualModalEdit'
import AnnualModalDelete from './modals/AnnualModalDelete'
import PageTasks from './PageTasks'
import PageDocuments from './PageDocuments'
import PageActivity from './PageActivity'

export default {
  props: ['annualId'],
  components: {
    ReviewsList,
    VueEditor,
    AnnualModalComplite,
    AnnualModalEdit,
    AnnualModalDelete,
    PageTasks,
    PageDocuments,
    PageActivity
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
      this.toast('Error', error.message, true)
    }
  },
  methods: {
    ...mapActions({
      updateAnnual: 'annual/updateReview',
      getCurrentReviewReview: 'annual/getCurrentReview'
    }),
    async saveGeneral (exit) {
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
                this.toast('Error', `${key}: ${value}`, true)
                this.errors = Object.assign(this.errors, { [key]: value })
              }
              console.log(this.errors)
              return
            }

            if (!response.errors) {
              this.toast('Success', "Saved changes to internal review.")

              if(exit) {
                setTimeout(() => {
                  //window.location.href = `${window.location.origin}/business/annual_reviews`
                  this.$router.push(`/business/annual_reviews`)
                }, 3000)
              }
            }
          })
          .catch((error) => console.error(error))

        await this.getCurrentReviewReview(this.annualId)

      } catch (error) {
        this.toast('Error', error.message, true)
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
                this.toast('Error', `${key}: ${value}`, true)
                this.errors = Object.assign(this.errors, { [key]: value })
              }
              return
            }

            if (!response.errors) {
              this.toast('Success', "Saved changes to internal review.")
            }
          })
          .catch((error) => console.error(error))
        this.toast('Success', "Internal review marked as complete!")
        await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.toast('Error', error.message, true)
      }
    },
    addEntry(){
      this.review.annual_review_employees.push({
        name: '',
        title: '',
        department: ''
      })
    },
    duplicateEntry(i) {
      this.review.annual_review_employees.push({...this.review.annual_review_employees[i+1]})
    },
    deleteEntry(i) {
      this.review.annual_review_employees.splice(i, 1);
    },
    deleteReview(reviewId){
      this.$store.dispatch('annual/deleteReview', { id: reviewId })
        .then(response => {
          this.toast('Success', `The internal review has been deleted! ${response.id}`)
          //window.location.href = `${window.location.origin}/business/annual_reviews`
          this.$router.push(`/business/annual_reviews`)
        })
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
    },
  }
}
</script>

<style scoped>
  .separator {
    color: #ffc107;
  }
</style>

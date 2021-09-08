<template lang="pug">
  .page.review
    .page-header.bg-white
      div
        h2.page-header__breadcrumbs Internal Review&nbsp;
          span.separator /&nbsp;
          b  {{ review ? review.name : '' }}
        h2.page-header__title: b {{ review ? review.name : '' }}
      .page-header__actions
        div
          button.btn.btn-default.mr-3.d-none Download
          button.btn.btn-dark.mr-3(@click="saveGeneral(true)") Save and Exit
          button.btn.btn__close(@click="backToList")
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
                :generalComplete="review.complete"
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
                      Errors(:errors="errors.review_start")
                    .col-6
                      label.form-label End Date
                      DatePicker(v-model="review.review_end")
                      Errors(:errors="errors.review_end")
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
                  .row.mb-3(v-for="(regulatory, index) in regulatoryChangesSplit" :key="index")
                    .col-5
                      label.form-label Change
                      textarea.form-control(v-model.trim="regulatory[0].change" placeholder="Describe the change")
                      Errors(v-if="errors.regulatory && errors.regulatory[index] && errors.regulatory[index][0]" :errors="errors.regulatory[index][0]")
                    .col-5
                      label.form-label Response
                      textarea.form-control(v-model.trim="regulatory[1].change" placeholder="Describe the response")
                      Errors(v-if="errors.regulatory && errors.regulatory[index] && errors.regulatory[index][1]" :errors="errors.regulatory[index][1]")
                    .col-2
                      b-icon.remove-regulatory(v-if="regulatoryChangesSplit.length > 1" @click="removeRegulatoryChange(regulatory, index)" icon="x")
                  div.mt-3
                    button.btn.btn-default(@click="addRegulatoryChange")
                      b-icon.mr-2(icon='plus-circle-fill')
                      | New Entry
                .reviews__card--internal
                  .row
                    .col-md-12
                      h4 
                        b Key Employees Interviewed
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
                        template(v-for="(annualReviewEmployee, annualReviewEmployeeIndex) in employees")
                          .row(v-for="" :key="`${annualReviewEmployeeIndex}`")
                            .col-4
                              b-input-group.m-b-1
                                b-form-input.mb-2.mr-sm-2.mb-sm-0(v-model="annualReviewEmployee.name" placeholder='Enter Name')
                                Errors(v-if="errors.employees && errors.employees[annualReviewEmployeeIndex] && errors.employees[annualReviewEmployeeIndex]['name']" :errors="errors.employees[annualReviewEmployeeIndex]['name']")
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
                          b-button(variant='default' @click="addEntry")
                            b-icon.mr-2(icon='plus-circle-fill')
                            | New Entry
                        //b-input-group
                        //  b-button(variant='primary' class="btn-none" @click="addEntry")
                        //    b-icon.mr-2(icon='plus-circle-fill')
                        //    | Add Entry
                .d-flex.justify-content-end.m-t-20
                  button.btn.btn-default.m-r-1(@click="saveGeneral") Save
                  AnnualModalComplite(@compliteConfirmed="markComplete", :completedStatus="review.complete" :name="review.name" :inline="false")
                    button.btn(:class="'btn-dark'") Mark as {{ review.complete ? 'Incomplete' : 'Complete' }}
      b-tab(title="Tasks")
        Get(:reviewModel="`/api/business/annual_reports/${annualId}`" :etag="tasksEtag"): template(v-slot="{ reviewModel }")
          PageTasks(:review="reviewModel" @saved="newTasksEtag")
      b-tab(title="Documents")
        PageDocuments
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
import EtaggerMixin from '@/mixins/EtaggerMixin'

export default {
  mixins: [EtaggerMixin('tasksEtag')],
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
    }),
    regulatoryChangesSplit() {
      const regulatorys = []
      const regulatoryChanges = this.review.regulatory_changes.filter(item => !item['_destroy'])
      const length = regulatoryChanges.length - 1
      for(let i = 0; i < length;) {
        regulatorys.push([regulatoryChanges[i], regulatoryChanges[i+1]])
        i = i + 2
      }

      return regulatorys
    },
    employees() {
      return this.review.annual_review_employees.filter(item => !item['_destroy'])
    }
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
    validateRegulatory() {
      const regulatoryChangesSplitLength = this.regulatoryChangesSplit.length
      for(let i = 0; i <= regulatoryChangesSplitLength - 1; i++) {
        let obj = {}
        if (this.errors['regulatory']) {
          obj = this.errors['regulatory']
          obj[i] = {}
        } else {
          obj[i] = {}
        }
        if (!this.regulatoryChangesSplit[i][0].change) {
          obj[i][0] = ['Required field']
        }

        if (!this.regulatoryChangesSplit[i][1].change) {
          obj[i][1] = ['Required field']
        }

        if ((obj[i][0] && obj[i][0].length > 0)  || (obj[i][1] && obj[i][1].length > 0)) this.$set(this.errors, 'regulatory', obj)
      }
    },
    validateDateTime() {
      if (this.review.review_start && this.review.review_end) {
        if (this.review.review_start > this.review.review_end) {
          this.$set(this.errors, 'review_end', ['Date must occur after start date'])
        }
      }

      if (this.review.review_start && !this.review.review_end) {
        this.$set(this.errors, 'review_end', ['Start date require End date'])
      }

      if (!this.review.review_start && this.review.review_end) {
        this.$set(this.errors, 'review_start', ['End date require Start date'])
      }
    },
    validateEmployee() {
      if (this.review.annual_review_employees.length > 0) {
        const anualEmployees = this.review.annual_review_employees
        const errorObj = {}
        for(let i = 0; i <= anualEmployees.length - 1; i++) {
          const item = anualEmployees[i]  
          if (!item.name) {
            errorObj[i] = {}
            errorObj[i]['name'] = ['Required field']
          }
        }

        if (Object.keys(errorObj).length > 0) this.$set(this.errors, 'employees', errorObj)
      }
    },
    validate() {
      this.errors = {}
      this.validateRegulatory()
      this.validateDateTime()
      this.validateEmployee()
    },
    async saveGeneral (exit) {
      this.validate()
      if (Object.keys(this.errors).length > 0) {
        return
      }
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
              this.toast('Success', "Internal review has been saved.")
              exit && setTimeout(() => this.$router.push(`/business/annual_reviews`), 3000)
            } else {
              this.toast('Success', "Internal review has not been saved. Please try again.")
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
        complete: !this.review.complete,
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
    addRegulatoryChange() {
      this.review.regulatory_changes.push({
        change: '',
        timestamp: new Date().getTime()
      })

      this.review.regulatory_changes.push({
        change: '',
        timestamp: new Date().getTime() + 1
      })
    },
    removeRegulatoryChange(regulatory, index) {
      const change = regulatory[0]
      const response = regulatory[1]
      if (change.id && response.id) {
        change['_destroy'] = true
        response['_destroy'] = true
        const changeIndex = this.review.regulatory_changes.findIndex(item => item.id === change.id)
        const responseIndex = this.review.regulatory_changes.findIndex(item => item.id === response.id)
        if (changeIndex && responseIndex) {
          this.$set(this.review.regulatory_changes, changeIndex, change)
          this.$set(this.review.regulatory_changes, responseIndex, response)
        }
      } else {
        const changeIndex = this.review.regulatory_changes.findIndex(item => item.timestamp === change.timestamp)
        if (changeIndex) {
          this.review.regulatory_changes.splice(changeIndex, 2)
        }
      }
    },
    duplicateEntry(i) {
      this.review.annual_review_employees.push({...this.review.annual_review_employees[i+1]})
    },
    deleteEntry(i) {
      if (this.review.annual_review_employees[i].id) {
        const employee = this.review.annual_review_employees[i]
        employee['_destroy'] = true
        this.$set(this.review.annual_review_employees, i, employee)
      } else {
        this.review.annual_review_employees.splice(i, 1)
      }
      
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
    backToList() {
      this.$router.push({ name: 'annual-reviews' })
    }
  }
}
</script>

<style scoped>
  .separator {
    color: #ffc107;
  }

  .remove-regulatory {
    cursor: pointer;
    font-size: 30px;
    margin-top: 40px;
  }
</style>

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot
    b-modal.fade(:id="modalId" @close="hideModal" title="New Review")
      .row.m-b-1(v-if="reviewsOptions && reviewsOptions.length")
        .col-12
          label.form-label Template
          b-form-select(v-model="reviewSelected" :options="reviewsOptions")
      .row
        .col-12
          label.form-label Name
          input.form-control(v-model="annual_review.name" type="text" placeholder="Enter the name of your review" ref="input")
          Errors(:errors="errors.name")
      .row.m-t-1
        .col-6
          label.form-label Start Date
          DatePicker(v-model="annual_review.review_start")
          Errors(:errors="errors.review_start")
        .col-6
          label.form-label End Date
          DatePicker(v-model="annual_review.review_end")
          Errors(:errors="errors.review_end")

      template(slot="modal-footer")
        button.btn.btn-link(@click="hideModal") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import { DateTime } from 'luxon'

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
        type: Array,
        required: false,
        default: []
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        annual_review: {
          name: '',
          year: year,
          review_start: '',
          review_end: ''
        },
        reviewSelected: null,
        errors: {}
      }
    },
    methods: {
      ...mapActions({
        createReview: 'annual/createReview',
        updateReview: 'annual/updateReview',
        duplicateReview: 'annual/duplicateReview',
      }),
      hideModal() {
        this.errors = {}
        this.$bvModal.hide(this.modalId)
      },
      validates() {
        const fields = ['name', 'review_start', 'review_end']
        fields.forEach(field => {
          const errors = []
          if (!this.annual_review[field]) {
            errors.push('Required field')
          }

          if (field === 'review_end' && this.annual_review.review_start && this.annual_review.review_end) {
            if (this.annual_review.review_start > this.annual_review.review_end) errors.push('Date must occur after start date')
          }
          
          if (errors.length > 0) {
            this.$set(this.errors, field, errors)
          } else {
            if (this.errors[field]) delete this.errors[field]
          }
        })
      },
      async submit(e) {
        e.preventDefault();
        this.validates()

        if (Object.keys(this.errors).length > 0) {
          return
        }

        if(this.reviewSelected) {
          this.$store.dispatch('annual/duplicateReview', { id: this.reviewSelected })
            .then(response => {
              // console.log(response)

              const review = response
              const data = {
                id: review.id,
                name: this.annual_review.name,
                year: year,
                review_start: this.annual_review.review_start,
                review_end: this.annual_review.review_end,
                regulatory_changes_attributes: review.regulatory_changes,
                material_business_changes: review.material_business_changes,
                annual_review_employees_attributes: review.annual_review_employees
              }

              this.$store.dispatch('annual/updateReview', data)
                .then(response => {
                  this.toast('Success', `Internal review has been created.`)
                  this.$emit('saved')
                  this.$bvModal.hide(this.modalId)
                  this.$router.push({ name: 'annual-reviews-general', params: { annualId: response.id } })
                })
                .catch(error => console.error(error))
            })
            .catch(error => this.toast('Error', `Internal review has not been created. Please try again. ${error.message}`, true))

          return
        }

        try {
          const response = await this.createReview(this.annual_review)
          if (response.errors) {
            this.toast('Error', `${response.status}`, true)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.toast(`Error`, `${prop}: ${err}`)))
            return
          }

          if (!response.errors) {
            this.toast('Success', `Internal review has been created.`)
            this.$emit('saved')
            this.$router.push({ name: 'annual-reviews-general', params: { annualId: response.id } })
          }

        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
    computed: {
      ...mapGetters({
        filefolders: 'filefolders/filefolders',
        currentFileFolders: 'filefolders/currentFileFolders',
        currentFolderId: 'filefolders/currentFolder',
        currentFolderName: 'filefolders/currentFolderName'
      }),
      reviewsOptions () {
        const revOpt = this.reviews.map(review => {
          return { value: review.id, text: review.name }
        })
        return revOpt ? revOpt : []
      },
    },
    watch: {
      'annual_review.review_start': {
        handler: function(value, oldVal) {
          const start = DateTime.fromSQL(value), end = DateTime.fromSQL(this.annual_review.review_end)
          if (!start.invalid && (end.invalid || (end.startOf('day') < start.startOf('day')))) {
            this.annual_review.review_end = value
          }
        }
      }
    }
  }
</script>

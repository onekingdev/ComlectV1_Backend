<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Review")
      .row(v-if="reviewsOptions && reviewsOptions.length")
        .col-12.m-b-2
          label.form-label Template
          b-form-select(v-model="reviewSelected" :options="reviewsOptions")
      .row
        .col-12.m-b-2
          label.form-label Name
          input.form-control(v-model="annual_review.name" type="text" placeholder="Enter the name of your review" ref="input")
      .row.m-b-2
        .col-6
          label.form-label Start Date
          DatePicker(v-model="annual_review.review_start")
        .col-6
          label.form-label Due Date
          DatePicker(v-model="annual_review.review_end")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Create
</template>

<script>
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
        // reviewsOptions: [
        //   { value: null, text: 'Please select an option' },
        //   { value: 'a', text: 'This is First option' },
        //   { value: 'b', text: 'Selected Option' },
        //   { value: { C: '3PO' }, text: 'This is an option with object value' },
        //   { value: 'd', text: 'This one is disabled', disabled: true }
        // ]
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
                .then((response) => {
                  this.makeToast('Success', `Annual Review Successfully created!`)
                  this.$emit('saved')
                  this.$bvModal.hide(this.modalId)
                })
                .catch((error) => console.error(error))
            })
            .catch(error => this.toast('Error', `Something wrong! ${error.message}`))

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

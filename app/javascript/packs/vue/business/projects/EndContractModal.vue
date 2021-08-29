<template lang="pug">
  div.d-inline-block(:class="{ 'float-right': right }")
    div.d-inline-block(v-b-modal="modalId"): slot
    b-modal.fade(:id="modalId" title="End Contract" no-stacking)
      .row.m-b-20
        .col-md-1.text-center.px-0
          b-icon.mt-1.ml-3(icon="exclamation-triangle-fill" scale="1.5" variant="warning")
        .col
          p.paragraph.m-b-10 Ending this contract will remove this specialist as a collaborator to the project, revoke their permissions to access your account, and payout the full contract price.
          p.paragraph.mb-0
            b Do you want to continue?
      .card
        .card-title.p-20
          UserAvatar(:user="project.specialist")
          .d-block.ml-3
            h5.mb-0.link {{ project.specialist.first_name }} {{project.specialist.last_name }}
            p.mb-0 {{ project.specialist.location }}
          .d-block.ml-auto.text-right
            span Outstanding Due
            h4 {{ 500 | usdWhole }}
        .card-body
          dl.row.mb-0
            dt.col-sm-3.label Project name
            dd.col-sm-9.text-right {{ project.title }}
          dl.row.mb-0
            dt.col-sm-3.label Payment method
            dd.col-sm-9.text-right {{ readablePaymentSchedule(project.payment_schedule) }}
          dl.row.mb-0
            dt.col-sm-3.label Date Issued
            dd.col-sm-9.text-right
          dl.row.mb-0
            dt.col-sm-3.label Payment Method
            dd.col-sm-9.text-right Transfer to Visa
        .card-footer.bg-white
          p.text-right.text-muted.mb-0 *Transactional fees lorem ipsum dolor.
      template(#modal-footer="{ hide }")
        button.btn.btn-link(@click="hide") Cancel
        Post(:action="completeUrl" :model="{}" @saved="contractEnded" @errors="$emit('errors', $event)")
          button.btn.btn-dark Confirm
    b-modal(:id="modalId + '_review'" title="Write a Review")
      p Please rate/describe your experience and leave any additional comments for the specialist!
      InputRating(v-model="review.value" :errors="errors.value") Rating
      InputTextarea(v-model="review.review" :errors="errors.review" placeholder="Describe your overall experience and leave any notes for the specialist")
      template(#modal-footer="{ hide }")
        button.btn.btn-link(@click="hide") Cancel
        button.btn.btn-dark(v-if="review.value === null" title="Please rate your experience" disabled) Submit
        Post(v-else :action="ratingUrl" :model="review" @saved="ratingSaved" @errors="submitErrors")
          button.btn.btn-dark Submit
</template>

<script>
import { readablePaymentSchedule } from '@/common/ProposalFields'

export default {
  props: {
    project: {
      type: Object,
      required: true
    },
    right: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      modalId: 'EndContractModal_' + Math.random().toFixed(12).replace('.', ''),
      review: {
        value: null,
        review: null
      },
      errors: {}
    }
  },
  methods: {
    readablePaymentSchedule,
    submitErrors(errors) {
      this.errors = errors
    },
    contractEnded() {
      this.$emit('saved')
      this.$bvModal.hide(this.modalId)
      this.$bvModal.show(this.modalId + '_review')
    },
    ratingSaved() {
      this.$emit('saved')
      this.$bvModal.hide(this.modalId + '_review')
    }
  },
  computed: {
    submitDisabled() {
      const threeOrLessStars = this.review.value && this.review.value <= 3,
        emptyReview = this.review.review === null || this.review.review === ''
      return this.review.value === null || (threeOrLessStars && emptyReview)
    },
    completeUrl() {
      return '/api/projects/' + this.project.id + '/end'
    },
    ratingUrl() {
      return '/api/projects/' + this.project.id + '/rating'
    }
  }
}
</script>

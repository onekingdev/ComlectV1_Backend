<template lang="pug">
  div.d-inline-block(:class="{ 'float-right': right }")
    div.d-inline-block(v-b-modal="modalId"): slot
    b-modal.fade(:id="modalId" title="End Contract" no-stacking)
      .row
        .col-sm-1
          b-icon.m-l-1(icon="exclamation-triangle-fill" scale="2" variant="warning")
        .col-sm
          p Ending this contract will remove this specialist as a collaborator to the project, revoke their permissions to access your account, and payout the full contract price.
          p: b Do you want to continue?
      .card
        .card-header
          .row
            .col-sm-7
              .row
                .col-2.pt-2
                  UserAvatar.userpic_small(:user="project.specialist")
                .col
                  <!--img.m-r-1.userpic_small(v-if="project.specialist.photo" :src="project.specialist.photo")-->
                  h3 {{ project.specialist.first_name }} {{project.specialist.last_name }}
                  p Specialist
            .col-sm
              span.float-right Outstanding Due <br> {{ 500 | usdWhole }}
        .card-header
          p
            b Project name
            span.float-right {{ project.title }}
          p
            b Payment method
            span.float-right {{ readablePaymentSchedule(project.payment_schedule) }}
          p
            b Date Issued
            span.float-right
          p
            b Payment Method
            span.float-right Transfer to Visa
        .card-header
          p.text-right.text-muted *Transactional fees lorem ipsum dolor.
      template(#modal-footer="{ hide }")
        button.btn.btn-link(@click="hide") Cancel
        Post(:action="completeUrl" :model="{}" @saved="contractEnded" @errors="$emit('errors', $event)")
          button.btn.btn-dark.m-r-1 Confirm
    b-modal(:id="modalId + '_review'" title="Write a Review")
      p Please rate/describe your experience and leave any additional comments for the specialist!
      InputRating(v-model="review.value") Rating
      InputTextarea(v-model="review.review" placeholder="Describe your overall experience and leave any notes for the specialist")
      .form-text.text-muted Optional
      template(#modal-footer="{ hide }")
        button.btn.btn-link(@click="hide") Cancel
        button.btn.btn-dark(v-if="review.value === null" title="Please rate your experience" disabled) Submit
        Post(v-else :action="ratingUrl" :model="review" @saved="ratingSaved" @errors="$emit('errors', $event)")
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
      }
    }
  },
  methods: {
    readablePaymentSchedule,
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
    completeUrl() {
      return '/api/projects/' + this.project.id + '/end'
    },
    ratingUrl() {
      return '/api/projects/' + this.project.id + '/rating'
    }
  }
}
</script>

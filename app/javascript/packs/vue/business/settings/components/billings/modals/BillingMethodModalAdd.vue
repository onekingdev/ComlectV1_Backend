<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Add Billing Method" hide-footer)
      .row
        .col-12.m-b-1
          .card
            .card-body
              .d-flex.justify-content-between
                .d-flex.align-items-center
                  ion-icon(name="home-outline")
                  .d-flex.flex-column.ml-2
                    h3 Bank account
                    p Use your bank account for future payments
                .d-flex.ml-auto.align-items-center
                  b-icon(icon="chevron-right" font-scale="1")
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

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,

      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        // this.toast('Success', `....`)
        this.$emit('selected')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

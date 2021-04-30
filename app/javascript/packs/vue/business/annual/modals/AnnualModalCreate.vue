<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Review")
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
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        annual_review: {
          name: '',
          year: year,
          review_start: '',
          review_end: ''
        }
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
  }
</script>

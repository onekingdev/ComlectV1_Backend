<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Annual Review")
      b-row.m-b-2
        .col
          label.form-label New review name
          input.form-control(v-model="review.name" type="text" placeholder="Enter the name of your review" @keyup.enter="submit" ref="input")
          Errors(:errors="errors.name")

      b-row.m-b-2
        .col-6
          label.form-label Start Date
          DatePicker(v-model="review.review_start")
          Errors(:errors="errors.review_start")
        .col-6
          label.form-label Due Date
          DatePicker(v-model="review.review_end")
          Errors(:errors="errors.review_end")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      review: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        // review: {
        //   name: '',
        //   description: 'N/A',
        //   sections: [],
        // },
        errors: []
      }
    },
    methods: {
      focusInput() {
        this.$refs.input.focus();
      },
      makeToast(title, str, variant) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000, variant })
      },

      async submit (e) {
        e.preventDefault();
        this.errors = [];

        if (!this.review.name) {
          this.errors.push('Name is required.');
          this.makeToast('Error', 'Name is required', 'danger')
          return;
        }
        if (this.review.name.length <= 3) {
          this.errors.push({name: 'Name is very short, must be more 3 characters.'});
          this.makeToast('Error', 'Name is very short, must be more 3 characters', 'danger')
          return;
        }

        const review = this.review
        const data = {
          id: review.id,
          name: review.name,
          review_start: review.review_start,
          review_end: review.review_end,
          // regulatory_changes_attributes: review.regulatory_changes,
          // material_business_changes: review.material_business_changes,
          // annual_review_employees_attributes: review.annual_review_employees
        }
        try {
          await this.$store.dispatch('annual/updateReview', data)
            .then((response) => {
              // console.log('response', response)
              if (response.errors) {
                for (const [key, value] of Object.entries(response.errors)) {
                  console.log(`${key}: ${value}`);
                  this.makeToast('Error', `${key}: ${value}`)
                  this.errors = Object.assign(this.errors, { [key]: value })
                }
                // console.log(this.errors)
                return
              }

              if (!response.errors) {
                this.makeToast('Success', "Saved changes to annual review.")
                this.$emit('saved')
                this.$bvModal.hide(this.modalId)
              }
            })
            .catch((error) => console.error(error))

        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },

  }
</script>

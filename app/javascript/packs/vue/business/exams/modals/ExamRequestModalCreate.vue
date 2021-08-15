<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Add request")
      .row
        .col-12.m-b-2
          label.form-label Requested Item
          input.form-control(v-model="requst.name" type="text" placeholder="Enter the item name" ref="input" @keyup="onChange")
          Errors(:errors="errors.name")
      .row.m-b-2
        .col-12
          label.form-label Details
          textarea.form-control(v-model="requst.details" rows="4")
          small(class="form-text text-muted") Optional
          Errors(:errors="errors.details")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Add
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  var today = new Date();

  const initialReqeust = () => ({
    name: '',
    details: '',
    complete: false,
    shared: false
  })

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      examId: {
        type: Number,
        default: true
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        requst: initialReqeust() ,
        errors: []
      }
    },
    methods: {
      resetForm() {
        this.requst = initialReqeust()
      },
      onChange(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.submit(e)
        }
      },
      async submit(e) {
        e.preventDefault();

        if (!this.requst.name || !this.requst.details) {
          this.toast('Error', `Please check all fields!`, true)
          return
        }

        try {
          await this.$store.dispatch('exams/createExamRequest', {
            id: this.examId,
            request: this.requst
          })
            .then(response => {
              this.toast('Success', `Exam Request successfully added!`)
              this.$emit('saved')
              this.$bvModal.hide(this.modalId)
              this.resetForm()
            })
            .catch(error => this.toast('Error', error.message, true))
        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
    computed: {
      datepickerOptions() {
        return {
          min: today
        }
      },
    },
  }
</script>

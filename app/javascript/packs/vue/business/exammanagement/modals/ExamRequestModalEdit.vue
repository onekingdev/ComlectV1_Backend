<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit request" @shown="getData")
      .row
        .col-12.m-b-2
          label.form-label Requested Item
          input.form-control(v-model="requestData.name" type="text" placeholder="Enter the item name" ref="input" @keyup="onChange")
          Errors(:errors="errors.name")
      .row.m-b-2
        .col-12
          label.form-label Details
          textarea.form-control(v-model="requestData.details" rows="4")
          small(class="form-text text-muted") Optional
          Errors(:errors="errors.details")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  var today = new Date();

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      examId: {
        type: Number,
        default: true
      },
      request: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        requestData: {
          name: '',
          details: '',
          complete: false,
          shared: false
        },
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      resetForm() {
        this.requestData = {
          name: '',
          details: '',
        }
      },
      onChange(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.submit(e)
        }
      },
      async submit(e) {
        e.preventDefault();

        if (!this.requestData.name || !this.requestData.details) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        try {
          await this.$store.dispatch('exams/updateExamRequest', {
            id: this.examId,
            request: this.requestData
          })
            .then(response => {
              this.makeToast('Success', `Exam Request successfully added!`)
              this.$emit('saved')
              this.$bvModal.hide(this.modalId)
              this.resetForm()
            })
            .catch(error => this.makeToast('Error', error.message))
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },

      getData() {
        this.requestData = {
          ...this.request
        }
      }
    },
    computed: {
      datepickerOptions() {
        return {
          min: today
        }
      },
    },
    // mounted() {
    //   getData()
    // },
  }
</script>

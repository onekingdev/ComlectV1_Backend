<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Exam")
      .row
        .col-12.m-b-2
          label.form-label Name
          input.form-control(v-model="exam_management.name" type="text" placeholder="Enter the name of your exam" ref="input")
      .row.m-b-2
        .col-6
          label.form-label Start Date
          DatePicker(v-model="exam_management.exam_start")
        .col-6
          label.form-label Due Date
          DatePicker(v-model="exam_management.exam_end")

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
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        exam_management: {
          name: '',
          exam_start: '',
          exam_end: ''
        },
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      async submit(e) {
        e.preventDefault();

        if (!this.exam_management.name || !this.exam_management.exam_start || !this.exam_management.exam_end) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        try {
          const response = await this.$store.dispatch('exammanagement/createExam', this.exam_management)
          if (response.errors) {
            this.makeToast('Error', `${response.status}`)
            Object.keys(response.errors)
              .map(prop => response.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
            return
          }
          this.makeToast('Success', `Exam Management successfully created!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
    computed: {

    },
  }
</script>

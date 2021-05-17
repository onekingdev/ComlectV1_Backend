<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Exam")
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
      exam: {
        type: Object,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        exam_management: {
          id: this.exam.id,
          name: this.exam.name,
          exam_start: this.exam.exam_start,
          exam_end: this.exam.exam_start
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
          await this.$store.dispatch('exams/updateExam', this.exam_management)
          this.makeToast('Success', `Exam Management successfully updated!`)
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

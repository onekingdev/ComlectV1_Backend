<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Exam")
      .row
        .col-12.m-b-2
          label.form-label Name
          input.form-control(v-model="exam_management.name" type="text" placeholder="Enter the name of your exam" ref="input" @keyup="onChange")
      .row.m-b-2
        .col-6
          label.form-label Start Date
          DatePicker(v-model="exam_management.starts_on" :options="datepickerOptions")
        .col-6
          label.form-label Due Date
          DatePicker(v-model="exam_management.ends_on" :options="datepickerOptions")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import { DateTime } from 'luxon'
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  const initialExam = () => ({
    id: '',
    name: '',
    starts_on: '',
    ends_on: ''
  })

  export default {
    mixins: [EtaggerMixin()],
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      exam: {
        type: Object,
        required: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        exam_management: initialExam(),
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      onChange(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.submit(e)
        }
      },
      async submit(e) {
        e.preventDefault();

        if (!this.exam_management.name || !this.exam_management.starts_on || !this.exam_management.ends_on) {
          this.makeToast('Error', `Please check all fields!`)
          return
        }

        try {
          await this.$store.dispatch('exams/updateExam', this.exam_management)
          this.makeToast('Success', `Exam Management successfully updated!`)
          this.$emit('saved')
          this.$bvModal.hide(this.modalId)
          this.newEtag()
        } catch (error) {
          this.makeToast('Error', error.message)
        }
      },
    },
    computed: {
      datepickerOptions() {
        return {
          min: new Date
        }
      },
    },
    mounted() {
      this.exam_management = Object.assign({}, this.exam_management, this.exam)
    },
  }
</script>

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Exam")
      .row
        .col-12.m-b-2
          label.form-label Name
          input.form-control(v-model.trim="exam_management.name" type="text" ref="input" @keyup="onChange")
          Errors(:errors="errors.name")
      .row.m-b-2
        .col-6
          label.form-label Start Date
          b-form-datepicker(v-model="exam_management.starts_on" :date-format-options="{ year: 'numeric', month: '2-digit', day: '2-digit' }" locale="en")
          Errors(:errors="errors.starts_on")
        .col-6
          label.form-label End Date
          b-form-datepicker(v-model="exam_management.ends_on" :date-format-options="{ year: 'numeric', month: '2-digit', day: '2-digit' }" locale="en")
          Errors(:errors="errors.ends_on")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
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
          starts_on: '',
          ends_on: ''
        },
        errors: {}
      }
    },
    methods: {
      resetForm() {
        this.exam_management = {
          name: '',
          starts_on: '',
          ends_on: ''
        }
      },
      onChange(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.submit(e)
        }
      },
      validate() {
        this.errors = {}
        const name = this.exam_management.name
        const startAt = this.exam_management.starts_on
        const endAt = this.exam_management.ends_on
        const requiredFields = ['name', 'starts_on', 'ends_on']
        
        for(let i = 0; i <= requiredFields.length - 1; i++) {
          if (!this.exam_management[requiredFields[i]]) this.errors[requiredFields[i]] = ['Required field']
        }

        if (name && name.length <= 3) {
          this.errors['name'] = ['Name must be more than 3 characters']
        }
        
        if (startAt && endAt && (startAt > endAt)) {
          this.errors['ends_on'] = ['Date must occur after start date']
        }
      },
      async submit(e) {
        e.preventDefault()
        this.validate()
        if (Object.keys(this.errors).length > 0) return

        try {
          await this.$store.dispatch('exams/createExam', this.exam_management)
            .then(response => {
              this.toast('Success', `Exam has been created.`)
              // this.$emit('saved')
              this.$bvModal.hide(this.modalId)
              this.resetForm()
            })
            .catch(error => this.toast('Error', `Exam has not been created.`, true) )
        } catch (error) {
          this.toast('Error', error.message, true)
        }
      },
    },
  }
</script>

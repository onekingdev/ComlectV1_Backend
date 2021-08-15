<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="New Exam")
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
      async submit(e) {
        e.preventDefault();

        if (!this.exam_management.name || !this.exam_management.starts_on || !this.exam_management.ends_on) {
          this.toast('Error', `Please check all fields!`, true)
          return
        }

        try {
          await this.$store.dispatch('exams/createExam', this.exam_management)
            .then(response => {
              this.toast('Success', `Exam Management successfully created!`)
              // this.$emit('saved')
              this.$bvModal.hide(this.modalId)
              this.resetForm()
            })
            .catch(error => this.toast('Error', `Something wrong! ${error}`, true) )
        } catch (error) {
          this.toast('Error', error.message, true)
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
  }
</script>

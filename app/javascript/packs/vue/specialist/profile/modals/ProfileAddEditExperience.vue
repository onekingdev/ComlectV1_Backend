<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Add Experience")
      .row
        .col-12.m-b-20
          label.form-label Title
          input.form-control(v-model="form.name" type="text" placeholder="Enter title/role at company" ref="input" @keyup="onChange")
          .invalid-feedback.d-block(v-if="errors.name") {{ errors.name[0] }}
      .row
        .col-12.m-b-20
          label.form-label Employer
          input.form-control(v-model="form.employer" type="text" placeholder="Enter company name" ref="input" @keyup="onChange")
          .invalid-feedback.d-block(v-if="errors.employer") {{ errors.employer[0] }}
      .row.m-b-20
        .col-6
          label.form-label Start Date
          DatePicker(v-model="form.starts_on" :options="datepickerOptions")
          .invalid-feedback.d-block(v-if="errors.starts_on") {{ errors.starts_on[0] }}
        .col-6
          label.form-label Due Date
          DatePicker(v-model="form.ends_on" :options="datepickerOptions")
          .invalid-feedback.d-block(v-if="errors.ends_on") {{ errors.ends_on[0] }}
      .row.m-b-20
        .col
          label.form-label Description
          b-form-textarea(id="textareaDescription"
          v-model="form.description"
          placeholder="Describe your role"
          rows="3"
          max-rows="6")
          .form-text.text-muted Max 1000 words
          .invalid-feedback.d-block(v-if="errors.description") {{ errors.description[0] }}

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.link(@click="$bvModal.hide(modalId)") Cancel
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
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: [],
        form: {
          name: '',
          employer: '',
          starts_on: '',
          ends_on: '',
          description: '',
        }
      }
    },
    methods: {
      onChange(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.submit(e)
        }
      },
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('compliteConfirmed')
        this.$bvModal.hide(this.modalId)
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

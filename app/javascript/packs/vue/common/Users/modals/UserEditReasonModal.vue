<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Reason")
      .row
        .col-12
          label.form-label Reason
          ComboBox(v-model="user.reason" :options="reasonOptions" placeholder="Select a reason")
          .invalid-feedback.d-block(v-if="errors.reason") {{ errors.reason }}
          Errors(:errors="errors.reason")
      .row.m-t-1
        .col-12
          label.form-label Additional Information
          textarea.form-control(v-model="user.description" rows=3)
          .invalid-feedback.d-block(v-if="errors.description") {{ errors.description }}
          .form-text.text-muted Optional
          Errors(:errors="errors.description")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: id })

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
        user: {
          reason: '',
          description: '',
        },
        errors: {},
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        this.errors = [];
        this.$emit('confirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
    computed: {
      reasonOptions() {
        return ['Termination', 'Registration', 'Temporary', 'Others'].map(toOption)
      }
    }
  }
</script>

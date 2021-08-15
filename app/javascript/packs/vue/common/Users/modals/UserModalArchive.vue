<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="archiveStatus ? 'Undisable User' : 'Disable User'")
      .row
        .col-md-1.text-center.px-0
          b-icon.modal-body__icon.mt-2.ml-3(icon="exclamation-triangle-fill" variant="warning")
        .col
          p.mb-0 Archiving the user will remove any permissions and access granted to them.
          p.m-b-10 Please select a reason for disabling the user.
          p.mb-0
            b Do you want to continue?

      .row.m-t-1
        .col-12
          label.form-label Reason
          ComboBox(v-model="user.reason" :options="reasonOptions" placeholder="Select a reason" @input="reasonChange")
          .invalid-feedback.d-block(v-if="errors.reason") {{ errors.reason }}
          Errors(:errors="errors.reason")
      .row.m-t-1(v-if="showTextArea")
        .col-12
          label.form-label Additional Information
          textarea.form-control(v-model="user.description" rows=3)
          .invalid-feedback.d-block(v-if="errors.description") {{ errors.description }}
          .form-text.text-muted Optional
          Errors(:errors="errors.description")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Confirm
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
      archiveStatus: {
        type: Boolean,
        required: true
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
        showTextArea: false
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('archiveConfirmed')
        this.$bvModal.hide(this.modalId)
      },
      reasonChange (value) {
        if (value === 'Others') this.showTextArea = true
        if (value !== 'Others') this.showTextArea = false
      }
    },
    computed: {
      reasonOptions() {
        return ['Termination', 'Registration', 'Temporary', 'Others'].map(toOption)
      }
    }
  }
</script>

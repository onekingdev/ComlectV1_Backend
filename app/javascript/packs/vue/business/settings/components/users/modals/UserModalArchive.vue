<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="archiveStatus ? 'Disable User' : 'Undisable User'")
      .row
        .col-md-1.text-center.px-0
          b-icon.mt-2.ml-3(icon="exclamation-triangle-fill" scale="2" variant="warning")
        .col
          p Archiving the user will remove any permissions and access granted to them.
          p Please select a reason for disabling the user.
            br
            b Do you want to continue?

      .row
        .col-12.m-b-1
          label.form-label Reason
          ComboBox(v-model="user.reason" :options="reasonOptions" placeholder="Select a reason" @input="reasonChange")
          Errors(:errors="errors.reason")
      .row
        .col-12.m-b-1
          label.m-t-1.form-label Additional Information
          textarea.form-control(v-model="user.description" rows=3)
          Errors(:errors="user.description")
          .form-text.text-muted Optional

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
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
        errors: {}
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
        console.log(value)
      }
    },
    computed: {
      reasonOptions() {
        return ['Termination', 'Registration', 'Temporary', 'Others'].map(toOption)
      }
    }
  }
</script>

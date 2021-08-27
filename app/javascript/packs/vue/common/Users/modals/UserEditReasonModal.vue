<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Edit Reason" @shown="getData")
      .row
        .col-12
          label.form-label Reason
          ComboBox(v-model="form.reason" :options="reasonOptions" placeholder="Select a reason")
          .invalid-feedback.d-block(v-if="errors.reason") {{ errors.reason }}
          Errors(:errors="errors.reason")
      .row.m-t-1
        .col-12
          label.form-label Additional Information
          textarea.form-control(v-model="form.description" rows=3)
          .invalid-feedback.d-block(v-if="errors.description") {{ errors.description }}
          .form-text.text-muted Optional
          Errors(:errors="errors.description")

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  const toOption = id => ({ id, label: capitalize(id) })
  const capitalize = function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  }

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      user: {
        type: Object,
        default: true
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        form: {
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

        const data = {
          id: this.user.id,
          reason: this.form.reason,
        }
        if(this.form.description) data.description = this.form.description

        this.$emit('editReasonConfirmed', data)
        this.$bvModal.hide(this.modalId)

      },
      getData() {
        this.form = {
          reason: this.user.reason,
          description: this.user.description,
        }
      }
    },
    computed: {
      reasonOptions() {
        return ['', 'termination', 'resignation', 'temporary', 'other'].map(toOption)
      }
    }
  }
</script>

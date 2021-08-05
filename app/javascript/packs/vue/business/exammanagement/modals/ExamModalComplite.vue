<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="completedStatus ? 'Incomplie Exam' : 'Complie Exam'")
      .row
        .col
          p Marking the exam as complete will disable any links to access your requests.
          p You currrently have:
          p
            span.text-success {{ countCompleted }}&nbsp;
            | Reqeusts Complited
          p: b Do you want to continue?

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Confirm
</template>

<script>
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      completedStatus: {
        type: Boolean,
        default: true
      },
      countCompleted: {
        type: String,
        default: ''
      },
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: []
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('compliteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

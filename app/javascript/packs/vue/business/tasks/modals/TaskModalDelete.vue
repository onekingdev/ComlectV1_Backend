<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Delete task")
      .row
        .col-md-1.text-center.px-0
          img.mt-1.ml-3(src='@/assets/error_20.svg' width="25" height="25")
        .col
          p.m-b-10 {{ message }}
          p.mb-0
            b Do you want to continue?

      Errors(:errors="errors.title")

      template(slot="modal-footer")
        button.btn.btn-link.mr-2(@click="$bvModal.hide(modalId)") Cancel
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
      linkedTo: {
        type: Object,
        required: false,
        default: () => {},
      }
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        errors: []
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        this.errors = [];

        this.$emit('deleteConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
    computed: {
      message() {
        const linkedTo = this.linkedTo
        let message = `Deleting this task will also remove all messages and documents associated with this task.`
        if (linkedTo) {

          if(linkedTo.linkable_type === 'LocalProject') { message = `You are deleting a task that is linked to the following project: ${linkedTo.linkable_name}. Deleting this task will also remove all messages and documents associated with this task. Please check whether this deletion may impact your present project progress.` }
          if(linkedTo.linkable_type === 'CompliancePolicy') { message = `You are deleting a task that is linked to the following policies: ${linkedTo.linkable_name}. Deleting this task will also remove all messages and documents associated with this task. Please check whether this deletion may impact your present policies and procedures.`}
          if(linkedTo.linkable_type === 'AnnualReport') { message = `You are deleting a task that is linked to an internal review: ${linkedTo.linkable_name}. Deleting this task will also remove all messages and documents associated with this task. Please check whether this deletion may impact your internal review progress.` }
          if(linkedTo.linkable_type === 'Exam') { message = `You are deleting a task that is linked to an exam management: ${linkedTo.linkable_name}. Deleting this task will also remove all messages and documents associated with this task. Please check whether this deletion may impact your exam management progress.` }

        }
        return message
      }
    }
  }
</script>

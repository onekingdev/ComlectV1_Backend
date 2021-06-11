<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Messages" size="xl")
      b-row
        .col-lg-6.pr-2
          .card
            .card-title
              SpecialistDetails
            .card-body sadasd


        .col-lg-6.pl-2
          .card
            .card-title Messages
            .card-body.white-card-body.reviews__card.p-0
              b-row
                .col.text-center
                  .card-body.p-3
                    h4 No Comments to Display
                    p Type in the comment box below to get started
              hr
              b-row
                .col
                  .card-body.p-3.position-relative
                    label.form-label Comment
                    VueEditor(v-model="message.comment" :editor-toolbar="customToolbar")
                    button.btn.btn-dark.save-comment-btn Send

      template(slot="modal-footer")
        button.btn.link(@click="$bvModal.hide(modalId)") Exit
        button.btn.btn-default(@click="submit") Add to Contacts
        button.btn.btn-dark(@click="submit") Invite to Project
</template>

<script>
  import { VueEditor } from "vue2-editor";
  import SpecialistDetails from "../../../../projects/SpecialistDetails";
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
    },
    components: {
      VueEditor,
      SpecialistDetails
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        message: {
          comment: ''
        },
        errors: {},
        customToolbar: [
          ["bold", "italic", "underline"],
          ["blockquote"],
          [{ list: "bullet" }],
          ["link"]
        ],
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        this.errors = [];

        // this.$emit('archiveConfirmed')
        this.$bvModal.hide(this.modalId)
      },
    },
  }
</script>

<style scoped>
  .save-comment-btn {
    position: absolute;
    right: 2rem;
    bottom: 2rem;
  }
</style>

<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Messages" size="xl")
      b-row
        .col-lg-6.pr-lg-2
          .card
            .card-body.p-0
              .row
                .col
                  .d-flex.align-items-center.p-x-2.p-y-1
                    UserAvatar(:user="item.specialist")
                    .d-block.m-l-2
                      h3 {{ item.specialist.first_name }} {{ item.specialist.last_name }}
                      p.label.m-b-1 {{ item.specialist.address_1 }} {{ item.specialist.address_2 }}
                      // StarRating(:stars="4")
                      .d-flex
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star-fill' variant="warning" font-scale="1.5")
                        b-icon(icon='star' variant="warning" font-scale="1.5")
              .row.m-b-1
                .col
                  b-list-group.list-group__custom(horizontal)
                    b-list-group-item.d-flex.flex-column.flex-grow-1
                      h5.label.text-uppercase Rate
                      p.mb-0: b {{ item.specialist.rate }}
                    b-list-group-item.d-flex.flex-column.flex-grow-1
                      h5.label.text-uppercase Avaibility
                      p.mb-0: b {{ item.specialist.avaibility }}
                    b-list-group-item.d-flex.flex-column.flex-grow-1
                      h5.label.text-uppercase Total jobs
                      p.mb-0: b {{ item.specialist.totaljobs }} jobs
              .row
                .col
                  .d-block.p-x-2.p-y-1
                    dl.row
                      dt.col-sm-3.label About Me
                      dd.col-sm-9
                        | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
                      dt.col-sm-3.label Industry
                      dd.col-sm-9
                        p Vestibulum id
                        p Donec id elit non mi porta gravida at eget metus.
                      dt.col-sm-3.label Jurisdiction
                      dd.col-sm-9 Etiam porta sem malesuada magna mollis euismod.

                      dt.col-sm-3.label Experience
                      dd.col-sm-9
                        dl.row
                          dt.col-sm-6
                            p.m-b-0 OCIE
                            p.m-b-0.font-italic Exam manager
                          dd.col-sm-6.text-right.text-black 2009-2014
                      dt.col-sm-3.label Education
                      dd.col-sm-9
                        dl.row
                          dt.col-sm-6 Nested definition list
                          dd.col-sm-6.text-right.text-black 1998-2001
        .col-lg-6.pl-lg-2
          .card-body.white-card-body.reviews__card.p-0
            b-row
              .col.p-y-1.mx-3
                h4 Messages
            hr.my-0
            b-row
              .col.text-center
                .card-body.px-3.py-1
                  .messages.d-none
                    h4 No Comments to Display
                    p.mb-0 Type in the comment box below to get started
                  .messages
                    .message
                      .d-flex.align-items-start
                        UserAvatar(:user="item.specialist")
                        .d-block.text-left.m-l-1
                          p.m-b-0: b {{ item.specialist.first_name }} {{ item.specialist.last_name }} attached a file
                          p.m-b-1 Here you go!
                          .row
                            .col-12
                              .file-card(v-if="files" v-for="(file, key) in files")
                                div.mr-2
                                  b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                                div.ml-0.mr-auto
                                  p.file-card__name: b {{ file.name }}
                                  .file-card__link.link Download
                                div.ml-auto.align-self-start
                                  button.btn.btn__close.file-card__close(@click="removeFile(key)")
                                    b-icon(icon="x" font-scale="1")
                        .d-block.text-right.ml-auto
                          p.label.mb-0 10 hours ago
                    .message
                      .d-flex.align-items-start
                        UserAvatar(:user="item.specialist")
                        .d-block.text-left.m-l-1
                          p.m-b-0: b {{ item.specialist.first_name }} {{ item.specialist.last_name }} attached a file
                          p.m-b-1 Here you go!
                        .d-block.text-right.ml-auto
                          p.label.mb-0 10 hours ago
            hr
            b-row
              .col
                .card-body.p-3.position-relative
                  label.form-label Comment
                  VueEditor(v-model="message.comment" :editor-toolbar="customToolbar" placeholder="Make a comment or leave a note...")
                  button.btn.btn-dark.save-comment-btn Send

      template(slot="modal-footer")
        button.btn.link(@click="$bvModal.hide(modalId)") Exit
        button.btn.btn-default(@click="submit") Add to Contacts
        button.btn.btn-dark(@click="submit") Invite to Project
</template>

<script>
  import { VueEditor } from "vue2-editor";
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      item: {
        type: Object,
        required: true
      },
    },
    components: {
      VueEditor,
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
        files: null
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
  .label {
    color: #797b7e;
  }
  .text-black {
    color: #464647;
  }
  .list-group__custom {
    padding-top: 1rem;
    padding-bottom: 1rem;
    border-right: none;
    border-left: none;
  }

  .save-comment-btn {
    position: absolute;
    right: 2rem;
    bottom: 2rem;
  }

  .messages {
    /*padding: 1rem;*/
    max-height: 200px;
    overflow: auto;
  }
  .message {
    padding-top: 1rem;
    padding-bottom: 1rem;
  }
  .message:not(:last-child) {
    /*margin-bottom: 1rem;*/
    border-bottom: solid 1px #e2e8f0;
  }
</style>

<style>

</style>

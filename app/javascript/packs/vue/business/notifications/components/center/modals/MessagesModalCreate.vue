<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Messages" size="xl")
      .row
        .col-lg-6.pr-lg-2
          .card.messages-info
            .card-body.p-0
              .messages-info__internal.d-flex.align-items-center
                UserAvatar(:user="item.specialist" :bg="true")
                .d-block.m-l-2
                  h5.messages-info__title {{ item.specialist.first_name }} {{ item.specialist.last_name }}
                  .messages-info__state {{ item.state }}
                  StarsRating(:rate="Math.floor(Math.random() * 5)")
                b-icon.linkedin.ml-auto.mt-auto(icon='linkedin' font-scale="1.5")
              .messages-info__list
                .messages-info__item
                  .messages-info__item-title Rate
                  .messages-info__item-text {{ item.specialist.rate }}
                .messages-info__item
                  .messages-info__item-title Availability
                  .messages-info__item-text {{ item.specialist.availability }}
                .messages-info__item
                  .messages-info__item-title Total jobs
                  .messages-info__item-text {{ item.specialist.total_jobs }} jobs
              .messages-info__internal
                dl.row.mb-0
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
          .card-body.white-card-body.messages-border.p-0
            .row
              .col.p-y-1.mx-3
                h5.mb-0 Messages
            hr.my-0
            .row
              .col
                .card-body.px-3.py-1
                  Messages(:messages="messages")
                  //.messages.d-none
                  //  h4 No Comments to Display
                  //  p.mb-0 Type in the comment box below to get started
                  //.messages
                  //  .message
                  //    .d-flex.align-items-start
                  //      UserAvatar(:user="item.specialist")
                  //      .d-block.text-left.m-l-1
                  //        p.m-b-0: b {{ item.specialist.first_name }} {{ item.specialist.last_name }} attached a file
                  //        p.m-b-0 Here you go!
                  //        .row
                  //          .col-12
                  //            .file-card(v-if="files" v-for="(file, key) in files")
                  //              div.mr-2
                  //                b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                  //              div.ml-0.mr-auto
                  //                p.file-card__name: b {{ file.name }}
                  //                .file-card__link.link Download
                  //              div.ml-auto.align-self-start
                  //                button.btn.btn__close.file-card__close(@click="removeFile(key)")
                  //                  b-icon(icon="x" font-scale="1")
                  //      .d-block.text-right.ml-auto
                  //        p.label.mb-0 10 hours ago
                  //  .message
                  //    .d-flex.align-items-start
                  //      UserAvatar(:user="item.specialist")
                  //      .d-block.text-left.m-l-1
                  //        p.m-b-0: b {{ item.specialist.first_name }} {{ item.specialist.last_name }} attached a file
                  //        p.m-b-1 Here you go!
                  //      .d-block.text-right.ml-auto
                  //        p.label.mb-0 10 hours ago
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
  import StarsRating from "../../../../marketplace/components/StarsRating";
  import Messages from '@/common/Messages'
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
      StarsRating,
      Messages,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        message: {
          comment: ''
        },
        messages: [{"id":42,"sender":{"first_name":"First","last_name":"Business","photo":null},"recipient":null,"message":"\u003cp\u003ewqewqe\u003c/p\u003e","file_data":null,"created_at":"2021-08-25T06:48:06.742Z"},{"id":41,"sender":{"first_name":"First","last_name":"Business","photo":null},"recipient":null,"message":"\u003cp\u003eqewqeqwe\u003c/p\u003e","file_data":null,"created_at":"2021-08-25T06:39:32.441Z"}],
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

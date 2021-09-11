<template lang="pug">
  b-modal.fade(:id="modalId" title="View Proposal" size="xl" no-stacking)
    .row
      .col-lg-6.pr-lg-2
        .card.messages-info
          .card-body.p-0
            .messages-info__internal.d-flex.align-items-center
              UserAvatar(:user="application.specialist" :bg="true")
              .d-block.m-l-2
                h5.messages-info__title {{ application.specialist.first_name }} {{ application.specialist.last_name }}
                .messages-info__state {{ application.specialist.location }}
                StarsRating(:rate="Math.floor(Math.random() * 5)")
              b-icon.linkedin.ml-auto.mt-auto(icon='linkedin' font-scale="1.5")
            .messages-info__list(v-if="application.pricing_type === 'fixed'")
              .messages-info__item
                .messages-info__item-title Bid Price
                .messages-info__item-text {{ application.fixed_budget | usdWhole }}
              .messages-info__item
                .messages-info__item-title Hourly
                .messages-info__item-text {{ application.hourly_rate | usdWhole }}
              .messages-info__item
                .messages-info__item-title Payment Schedule
                .messages-info__item-text {{ paymentScheduleReadable(application) }}
            .messages-info__internal
              dl.row.mb-0
                //dt.col-sm-3.label About Me
                //dd.col-sm-9
                //  | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
                dt.col-sm-3.label Start Date
                dd.col-sm-9 {{ application.starts_on | asDate }}
                dt.col-sm-3.label Due Date
                dd.col-sm-9 {{ application.ends_on | asDate }}

                dt.col-sm-3.label Role Details
                dd.col-sm-9 {{ application.role_details }}
                dt.col-sm-3.label Key Deliverables
                dd.col-sm-9 {{ application.key_deliverables }}
                dt.col-sm-3.label Attachment
                dd.col-sm-9(v-if="application.document")
                  a(:href="attachmentUrl(application.document)" target="_blank") {{ application.document.metadata.filename }}
                dd.col-sm-9(v-else) -

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
          hr
          b-row
            .col
              .card-body.p-3.position-relative
                label.form-label Comment
                Tiptap(v-model="message.comment" placeholder="Make a comment or leave a note...")
                button.btn.btn-dark.save-comment-btn Send

    template(#modal-footer="{ ok, cancel, hide }")
      button.btn.btn-light(@click="hide") Close
      button.btn.btn-outline-dark(v-if="!hasSpecialist(application.project)" v-b-modal="'DenyProposalConfirm'") Deny Proposal
      button.btn.btn-dark(v-if="!hasSpecialist(application.project)" v-b-modal="confirmModalId") Accept Proposal
</template>

<script>
import SpecialistDetails from './SpecialistDetails'
import { redirectWithToast } from '@/common/Toast'
import { FIXED_PAYMENT_SCHEDULE_OPTIONS } from '@/common/ProjectInputOptions'

import Tiptap from '@/common/Tiptap'
import StarsRating from "@/business/marketplace/components/StarsRating";
import Messages from '@/common/Messages'

export default {
  props: {
    modalId: {
      type: String,
      required: true
    },
    confirmModalId: {
      type: String,
      required: true
    },
    projectId: {
      type: Number,
      required: true
    },
    application: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      message: {
        comment: ''
      },
      messages: [],
      // messages: [{"id":42,"sender":{"first_name":"First","last_name":"Business","photo":null},"recipient":null,"message":"\u003cp\u003ewqewqe\u003c/p\u003e","file_data":null,"created_at":"2021-08-25T06:48:06.742Z"},{"id":41,"sender":{"first_name":"First","last_name":"Business","photo":null},"recipient":null,"message":"\u003cp\u003eqewqeqwe\u003c/p\u003e","file_data":null,"created_at":"2021-08-25T06:39:32.441Z"}],
      errors: {},
      files: null
    }
  },
  computed: {
    hasSpecialist: () => project => !!project.specialist_id,
    paymentScheduleReadable: () => application => FIXED_PAYMENT_SCHEDULE_OPTIONS[application.payment_schedule],
    attachmentUrl: () => document => `/uploads/${document.storage}/${document.id}`
  },
  components: {
    SpecialistDetails,
    Tiptap,
    StarsRating,
    Messages,
  }
}
</script>

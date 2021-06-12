<template lang="pug">
  b-list-group-item
    .row
      .col
        .d-flex.align-items-center
          .d-flex.align-items-center.justify-content-center.icon_width
            b-icon(v-if="item.type !== 'message'" icon="exclamation-triangle-fill" scale="2" variant="warning")
            UserAvatar(v-if="item.type === 'message'" :user="item.specialist")
          .d-block.ml-4
            h5 {{ item.specialist.first_name + ' ' + item.specialist.last_name }}
            p.mb-0 {{ item.message }}
            p.mb-0.time {{ item.created_at | dateToHuman }}
          .d-flex.justify-content-end.align-items-center.h-100.ml-auto
            b-badge.mr-2(variant="default") 1 New Message
            MessagesModalCreate(v-if="item.type === 'message'" :item="item" )
              b-button.btn.mr-2.font-weight-bold(type='button' variant='default') View
            .actions
              b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                template(#button-content)
                  b-icon(icon="three-dots")
                b-dropdown-item-button Edit
                b-dropdown-item-button.delete Delete
</template>

<script>
  import { DateTime } from 'luxon'
  import UserAvatar from '@/common/UserAvatar'
  import MessagesModalCreate from "../../center/modals/MessagesModalCreate";

  export default {
    name: "notifyItem",
    props: ['item'],
    components: {
      MessagesModalCreate,
      UserAvatar
    },
    data() {
      return {

      }
    },
    computed: {

    },
    methods: {

    },
    filters: {
      dateToHuman(value) {
        if (!value) return ''
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          // return date.toFormat('MM/dd/yyyy')
          return date.toLocaleString({ hour: '2-digit', minute: '2-digit', hour12: true })
        }
        if (date.invalid) {
          return value
        }
      },
    }
  }
</script>

<style scoped>
  .icon_width {
    width: 40px;
  }
  .time{
    color: #a4a5ab;
  }
</style>

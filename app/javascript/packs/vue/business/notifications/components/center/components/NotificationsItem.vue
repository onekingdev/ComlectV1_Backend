<template lang="pug">
  b-list-group-item
    .row
      .col-10
        .d-flex.align-items-center
          .d-flex.align-items-center.justify-content-center.icon_width
            b-icon(v-if="item.type !== 'message'" icon="exclamation-triangle-fill" scale="2" variant="warning")
            UserAvatar(v-if="item.type === 'message'" :user="item.specialist")
          .d-block.ml-4
            h5 {{ item.name }}&nbsp;
              a.link(:href="item.link") {{ item.linkName }}&nbsp;
              | is due tommorow
            p.mb-0.time {{ item.created_at | dateToHuman }}
      .col
        .d-flex.justify-content-end.align-items-center.h-100
          b-button.btn.mr-2.font-weight-bold(v-if="item.type === 'message'" type='button' variant='default') View
          button.btn.btn__close
            b-icon(icon="x" font-scale="1")
</template>

<script>
  import { DateTime } from 'luxon'
  import UserAvatar from '@/common/UserAvatar'

  export default {
    name: "notifyItem",
    props: ['item'],
    components: {
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

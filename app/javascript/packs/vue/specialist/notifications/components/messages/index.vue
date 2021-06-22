<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card.overflow-wrap
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Messages
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row
                .col
                  MessagesList(:messages="messages")
                  div(v-if="messages && !messages.length") Messages for today not exist
</template>

<script>
  // import { DateTime } from 'luxon'
  import Loading from '@/common/Loading/Loading'
  import MessagesList from "./components/MessagesList";

  // var today = DateTime.now().toLocaleString(DateTime.DATE_FULL)

  export default {
    components: {
      MessagesList,
      Loading,
    },
    data() {
      return {

      };
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      messages() {
        return [
          {
            id: 2,
            type: 'message',
            message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            specialist: {
              first_name: 'Abrrrr',
              last_name: 'Kadbrrr',
              address_1: 'Arizona, United States',
              rate: '$200/hr',
              avaibility: 'Open',
              totaljobs: 8,
            },
            name: 'Some 2 task 2 task',
            link: 'some link 2 ',
            linkName: 'someLinkName2 ',
            created_at: '2021-06-12T06:56:53.690Z',
            messages: {
              files: []
            }
          },
          {
            id: 3,
            type: 'message',
            message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            specialist: {
              first_name: 'Abrrrr',
              last_name: 'Kadbrrr',
            },
            name: 'Some 2 task 2 task',
            link: 'some link 2 ',
            linkName: 'someLinkName2 ',
            created_at: '2021-06-11T06:58:37.972Z',
            messages: {
              files: []
            }
          },
          {
            id: 4,
            type: 'message',
            message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            specialist: {
              first_name: 'Abrrrr',
              last_name: 'Kadbrrr',
            },
            name: 'Some 2 task 2 task',
            link: 'some link 2 ',
            linkName: 'someLinkName2 ',
            created_at: '2021-05-05T09:42:28.076Z',
            messages: {
              files: []
            }
          },
        ]
      },
    },
    mounted() {

    },
  };
</script>

<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Notification Center
          .card-body.white-card-body.px-3.px-xl-5
            .settings___card--internal.p-y-1
              .row.m-b-1
                .col
                  h4 Today
              .row
                .col
                  NotificationsList(:notifications="notifications")
                  div(v-if="!notifications && notifications.length") Notifications not avaliable
            //.settings___card--internal.p-y-1
            //  .row
            //    .col
            //      h4 Previous
            //  .row
            //    .col
            //      // div(v-if="!notifications && notifications.length") Notifications not avaliable
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import NotificationsList from "./components/NotificationsList";

  export default {
    components: {
      NotificationsList,
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
      notifications() {
        return [
          {
            id: 1,
            type: 'system',
            variant: 'warning',
            name: 'Some task task',
            link: 'some link',
            linkName: 'someLinkName',
            created_at: '2021-04-30T10:35:14.030Z',
          },
          {
            id: 2,
            type: 'message',
            specialist: {
              first_name: 'Abrrrr',
              last_name: 'Kadbrrr',
            },
            name: 'Some 2 task 2 task',
            link: 'some link 2 ',
            linkName: 'someLinkName2 ',
            created_at: '2021-05-04T06:56:53.690Z',
          },
          {
            id: 3,
            type: 'message',
            specialist: {
              first_name: 'Abrrrr',
              last_name: 'Kadbrrr',
            },
            name: 'Some 2 task 2 task',
            link: 'some link 2 ',
            linkName: 'someLinkName2 ',
            created_at: '2021-05-04T06:58:37.972Z',
          },
          {
            id: 4,
            type: 'message',
            specialist: {
              first_name: 'Abrrrr',
              last_name: 'Kadbrrr',
            },
            name: 'Some 2 task 2 task',
            link: 'some link 2 ',
            linkName: 'someLinkName2 ',
            created_at: '2021-05-05T09:42:28.076Z',
          },
          {
            id: 5,
            type: 'system',
            variant: 'warning',
            name: 'Some task task',
            link: 'some link',
            linkName: 'someLinkName',
            created_at: '2021-05-04T07:01:11.344Z',
          },
        ]
      },
    },
    mounted() {

    },
  };
</script>

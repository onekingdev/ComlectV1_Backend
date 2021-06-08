<template lang="pug">
  div.settings
    .container-fluid
      .row.p-t-3
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item
                a.settings-nav__link(href='#') General
              li.settings-nav__item
                a.settings-nav__link(href='#') Users
              li.settings-nav__item
                a.settings-nav__link(href='#') Role and Permisssions
              li.settings-nav__item
                a.settings-nav__link(href='#') Security
              li.settings-nav__item
                a.settings-nav__link(href='#') Subscriptions
              li.settings-nav__item
                a.settings-nav__link(href='#') Billings
              li.settings-nav__item
                a.settings-nav__link(href='#') Notifications
        .col-md-9 test2

</template>

<script>
  import Loading from '@/common/Loading/Loading'

  export default {
    components: {
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
    },
    mounted() {

    },
  };
</script>

<style>
  @import "./styles.css";
</style>

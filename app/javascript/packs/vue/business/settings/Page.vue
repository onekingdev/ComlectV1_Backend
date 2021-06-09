<template lang="pug">
  div.settings
    .container-fluid
      .row.p-t-3
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item(@click="openSetting('General')")
                a.settings-nav__link(href='#') General
              li.settings-nav__item(@click="openSetting('Users')")
                a.settings-nav__link(href='#') Users
              li.settings-nav__item(@click="openSetting('RolePermisssions')")
                a.settings-nav__link(href='#') Role and Permisssions
              li.settings-nav__item(@click="openSetting('Security')")
                a.settings-nav__link(href='#') Security
              li.settings-nav__item(@click="openSetting('Subscriptions')")
                a.settings-nav__link(href='#') Subscriptions
              li.settings-nav__item(@click="openSetting('Billings')")
                a.settings-nav__link(href='#') Billings
              li.settings-nav__item(@click="openSetting('Notifications')")
                a.settings-nav__link(href='#') Notifications
        .col-md-9
          component(v-bind:is="component")

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import General from "./components/general";
  import Users from "./components/users";
  import Security from "./components/security";
  import Subscriptions from "./components/subscriptions";

  export default {
    components: {
      Loading,
      General,
      Users,
      Security,
      Subscriptions,
    },
    created() {
      // this.component = General;
      // this.component = Users;
      // this.component = Security;
      this.component = Subscriptions;

      // console.log(window.location)
      // const pathName = window.location.pathname.split('settings/')
      // console.log(pathName)
    },
    data() {
      return {
        component: ''
      };
    },
    methods: {
      openSetting (name) {
        this.component = name;
        // const baseUrl = new URL(window.location.origin);
        // window.history.pushState({}, name, `${baseUrl}business/settings/${name.toLowerCase()}`);
      }
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

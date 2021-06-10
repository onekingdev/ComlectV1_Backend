<template lang="pug">
  div.settings
    .container-fluid
      .row.p-t-3
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item.active(@click="openSetting('General', $event)")
                a.settings-nav__link(href='#') General
              li.settings-nav__item(@click="openSetting('Users', $event)")
                a.settings-nav__link(href='#') Users
              li.settings-nav__item(@click="openSetting('RolePermisssions', $event)")
                a.settings-nav__link(href='#') Role and Permisssions
              li.settings-nav__item(@click="openSetting('Security', $event)")
                a.settings-nav__link(href='#') Security
              li.settings-nav__item(@click="openSetting('Subscriptions', $event)")
                a.settings-nav__link(href='#') Subscriptions
              li.settings-nav__item(@click="openSetting('Billings', $event)")
                a.settings-nav__link(href='#') Billings
              li.settings-nav__item(@click="openSetting('Notifications', $event)")
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
  import RolePermisssions from "./components/roles";
  import Billings from "./components/billings";

  export default {
    components: {
      Loading,
      General,
      Users,
      Security,
      Subscriptions,
      RolePermisssions,
      Billings,
    },
    created() {
      // this.component = General;
      // this.component = Users;
      // this.component = Security;
      // this.component = Subscriptions;
      // this.component = RolePermisssions;
      this.component = Billings;

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
      openSetting (name, event) {
        this.component = name;

        // const allLinks = document.querySelectorAll('.settings-nav__item')
        // console.log(allLinks)

        document.querySelectorAll('.settings-nav__item').forEach(function (link, i) {
          link.classList.remove('active')
        });
        event.target.classList.add('active')
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

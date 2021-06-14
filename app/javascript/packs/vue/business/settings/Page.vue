<template lang="pug">
  div.settings
    .container-fluid
      template(v-if='componentUpgrade')
        .row
          .col-md-9.mx-auto.my-2
            .card
              .card-body
                component(v-bind:is="componentUpgrade")
      .row.p-t-3(v-if='!componentUpgrade')
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item(v-for='(item, idx) in menu' :key="idx" @click="openSetting(item.name, $event)" :class="{ active: idx === 0 }")
                a.settings-nav__link(:href='item.link') {{ item.name }}
        .col-md-9
          component(v-bind:is="component" @upgradOpen="upgradOpen")

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import General from "./components/general";
  import Users from "./components/users";
  import Security from "./components/security";
  import Subscriptions from "./components/subscriptions";
  import RolePermisssions from "./components/roles";
  import Billings from "./components/billings";
  import Notifications from "./components/notifications";
  import SelectPlan from './components/subscriptions/components/SelectPlan'

  export default {
    components: {
      Loading,
      General,
      Users,
      Security,
      Subscriptions,
      RolePermisssions,
      Billings,
      Notifications,
      SelectPlan,
    },
    created() {
      this.component = General;
      // this.component = Users;
      // this.component = Security;
      // this.component = Subscriptions;
      // this.component = RolePermisssions;
      // this.component = Billings;
      // this.component = Notifications;

      // console.log(window.location)
      // const pathName = window.location.pathname.split('settings/')
      // console.log(pathName)
    },
    data() {
      return {
        component: '',
        componentUpgrade: '',
        menu: [
          { name: 'General', link: '#' },
          { name: 'Users', link: '#' },
          { name: 'Security', link: '#' },
          { name: 'Subscriptions', link: '#' },
          { name: 'RolePermisssions', link: '#' },
          { name: 'Billings', link: '#' },
          { name: 'Notifications', link: '#' },
        ]
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
      },
      upgradOpen() {
        // console.log('open')
        this.componentUpgrade = SelectPlan
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

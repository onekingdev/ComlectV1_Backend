<template lang="pug">
  div.settings
    .container-fluid
      template(v-if='componentUpgrade')
        .row
          .col-md-9.mx-auto.my-2
            .card
              .card-body
                component(v-bind:is="componentUpgrade" @upgradePlanComplited="upgradePlanComplited" @upgradeBillingComplited="upgradeBillingComplited")
      .row.p-t-3(v-if='!componentUpgrade')
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item(v-for='(item, idx) in menu' :key="idx" @click="openSetting(item.link, $event)" :class="{ active: item.link === component }")
                a.settings-nav__link(:href='item.link') {{ item.name }}
        .col-md-9
          component(v-bind:is="component" :states="states", :timezones="timezones", :contries="contries", :userId="userId" @openComponent="openComponent")

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import General from "./components/general";
  import Users from "./components/users";
  import Security from "./components/security";
  import Subscriptions from "./components/subscriptions";
  import Roles from "./components/roles";
  import Billings from "./components/billings";
  import Notifications from "./components/notifications";
  import SelectPlan from './components/subscriptions/components/SelectPlan'
  import SelectBilling from './components/billings/components/SelectBilling'

  export default {
    props: ['states', 'timezones', 'contries', 'userId'],
    components: {
      Loading,
      General,
      Users,
      Security,
      Subscriptions,
      Roles,
      Billings,
      Notifications,
      SelectPlan,
      SelectBilling,
    },
    created() {
      // this.component = General;
      // this.component = Users;
      // this.component = Security;
      // this.component = Subscriptions;
      // this.component = Roles;
      // this.component = Billings;
      // this.component = Notifications;

      const pathName = window.location.pathname.split('settings/')[1]
      if(pathName) {
        const pathNameFixed = pathName.charAt(0).toUpperCase() + pathName.slice(1);
        this.openSetting(pathNameFixed)
      }
      if(!pathName) this.openSetting('General')
    },
    data() {
      return {
        component: '',
        componentUpgrade: '',
        menu: [
          { name: 'General', link: 'General' },
          { name: 'Users', link: 'Users' },
          { name: 'Roles and Permisssions', link: 'Roles' },
          { name: 'Security', link: 'Security' },
          { name: 'Subscriptions', link: 'Subscriptions' },
          { name: 'Billings', link: 'Billings' },
          { name: 'Notifications', link: 'Notifications' },
        ]
      };
    },
    methods: {
      openSetting (name, event) {
        this.component = name;
        document.querySelectorAll('.settings-nav__item').forEach(function (link, i) {
          link.classList.remove('active')
        });
        if(event) event.target.classList.add('active')

        this.navigate(name)
      },
      openComponent (value) {
        this.componentUpgrade = value
      },
      upgradePlanComplited () {
        this.componentUpgrade = ''
        this.toast('Success', 'Plan upgraded.')
      },
      upgradeBillingComplited () {
        this.componentUpgrade = ''
        this.toast('Success', 'Billing upgraded.')
      },
      navigate(name) {
        const baseUrl = new URL(window.location.origin);
        window.history.pushState({}, name, `${baseUrl}business/settings/${name.toLowerCase()}`);
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

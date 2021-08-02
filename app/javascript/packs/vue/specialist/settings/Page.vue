<template lang="pug">
  div.settings
    .container-fluid
      template(v-if='componentUpgrade')
        .row
          .col-md-9.mx-auto.my-2
            .card
              .card-body
                component(v-bind:is="componentUpgrade" @upgradePlanComplited="upgradePlanComplited")
      .row.p-t-3(v-if='!componentUpgrade')
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item(v-for='(item, idx) in menu' :key="idx" @click="openSetting(item.component)" :class="{ active: item.link === component }")
                a.settings-nav__link(:href='item.link' @click.prevent) {{ item.name }}
        .col-md-9
          component(v-bind:is="component" @addMethodOpen="addMethodOpen")

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import General from "./components/general";
  import Users from "./components/users";
  import Security from "./components/security";
  import Subscriptions from "./components/subscriptions";
  import ClientPermisssions from "./components/roles";
  import Billings from "./components/billings";
  import Notifications from "./components/notifications";
  import SelectBilling from './components/billings/components/SelectBilling'

  export default {
    components: {
      Loading,
      General,
      Users,
      Security,
      Subscriptions,
      ClientPermisssions,
      Billings,
      Notifications,
      SelectBilling,
    },
    created() {
      this.component = General;
      // this.component = Users;
      // this.component = Security;
      // this.component = Subscriptions;
      // this.component = ClientPermisssions;
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
          { name: 'General', link: 'general', component: General },
          { name: 'Client Permisssions', link: 'roles', component: ClientPermisssions },
          { name: 'Users', link: 'users', component: Users },
          { name: 'Security', link: 'security', component: Security },
          { name: 'Subscriptions', link: 'subscriptions', component: Subscriptions },
          { name: 'Billings', link: 'billings', component: Billings },
          { name: 'Notifications', link: 'notifications', component: Notifications },
        ]
      };
    },
    methods: {
      openSetting (name) {
        this.component = name
      },
      addMethodOpen () {
        // console.log('open')
        this.componentUpgrade = SelectBilling
      },
      upgradePlanComplited () {
        // console.log('open')
        this.componentUpgrade = ''
        this.toast('Success', 'Plan upgraded.')
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

<template lang="pug">
  .settings
    .container-fluid
      template(v-if='componentUpgrade')
        .row
          .col-md-9.mx-auto.my-2
            .card
              .card-body
                component(v-bind:is="componentUpgrade" @upgradePlanComplited="upgradePlanComplited" @upgradeBillingComplited="upgradeBillingComplited")
      .row.p-40.p-y-20(v-if='!componentUpgrade')
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item(v-for='(item, idx) in menu' :key="idx" @click="openSetting(item.component)" :class="{ active: item.link === component }")
                a.settings-nav__link(:href='item.link' @click.prevent) {{ item.name }}
        .col-md-9
          component(v-bind:is="component" :states="states", :timezones="timezones", :contries="contries", :userId="userId" @openComponent="openComponent")

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import General from "./components/general";
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
      Security,
      Subscriptions,
      ClientPermisssions,
      Billings,
      Notifications,
      SelectBilling,
    },
    created() {
      this.component = General;
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
          { name: 'Client Permissions', link: 'roles', component: ClientPermisssions },
          { name: 'Security', link: 'security', component: Security },
          { name: 'Subscriptions', link: 'subscriptions', component: Subscriptions },
          { name: 'Billings', link: 'billings', component: Billings },
          { name: 'Notifications', link: 'notifications', component: Notifications },
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
        window.history.pushState({}, name, `${baseUrl}specialist/settings/${name.toLowerCase()}`);
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  };
</script>

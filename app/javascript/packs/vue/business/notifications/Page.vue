<template lang="pug">
  div.settings
    .container-fluid
      .row.p-t-3
        .col-md-3
          .panel-default
            ul.settings-nav
              li.settings-nav__item(v-for='(item, idx) in menu' :key="idx" @click="openSetting(item.name, $event)" :class="{ active: idx === 0 }")
                a.settings-nav__link(:href='item.link') {{ item.name }}
        .col-md-9
          component(v-bind:is="component")

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import NotificationCenter from "./components/сenter";

  export default {
    components: {
      Loading,
      NotificationCenter
    },
    created() {
      this.component = NotificationCenter;
      // this.component = Users;

      // console.log(window.location)
      // const pathName = window.location.pathname.split('settings/')
      // console.log(pathName)
    },
    data() {
      return {
        component: '',
        menu: [
          { name: 'NotificationCenter', link: '#' },
          { name: 'Messages', link: '#' },
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

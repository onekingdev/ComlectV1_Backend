<template lang="pug">
  .topbar
    b-navbar.p-0(toggleable='lg')
      b-navbar-toggle(target='nav-collapse')
      b-collapse#nav-collapse.topbar-menu(is-nav)
        ul.topbar-menu__list
          li.nav-item.topbar-menu__item(@click="openLink('default')")
            router-link.topbar-menu__link(:to='`/${userType}`' active-class="active" exact) Home
          li.nav-item.topbar-menu__item(@click="openLink('documents')")
            router-link.topbar-menu__link(:to='`/${userType}/file_folders`' active-class="active") Documents
          li.nav-item.topbar-menu__item(@click="openLink('default')")
            router-link.topbar-menu__link(:to='`/${userType}/reports/risks`' active-class="active") Reports
          li.nav-item.topbar-menu__item.d-none
            a.topbar-menu__link(aria-current='page' href='#') Community
    // Right aligned nav items
    b-navbar-nav.flex-row.align-items-center.ml-auto.h-100
      router-link.btn.btn-warning.btn-topbar.btn-topbar_find(v-if="userType === 'business'" :to='`/${userType}/specialists`') Find an Expert
      router-link.btn.btn-warning.btn-topbar.btn-topbar_find(v-if="userType === 'specialist'" :to='`/${userType}/projects-marketpalce`') Browse Projects
      router-link.btn.btn-topbar.btn-topbar_notify(:to='`/${userType}/settings/notification-center`')
        ion-icon(name='notifications-outline')
      b-nav-item-dropdown.topbar-right-dropdown.actions(right)
        // Using 'button-content' slot
        template(#button-content)
          UserAvatar.topbar-right-dropdown__avatar(:user="account" :sm="true")
          | {{ account.first_name }} {{ account.last_name }}
          ion-icon.topbar-right-dropdown__icon(name='chevron-down-outline')
        li(@click="openLink('documents')")
          router-link.dropdown-item(:to='`/${userType}/settings`' active-class="active") Settings
        b-dropdown-item(@click="signOut") Sign Out
      a.btn.btn-topbar.btn-topbar_help(href="#")
        b-icon.mr-2( icon="question-circle-fill" aria-label="Help")
        | Help
</template>

<script>
  // import { mapActions, mapGetters } from "vuex"
  import UserAvatar from '@/common/UserAvatar'

  export default {
    name: "index",
    components: {
      UserAvatar
    },
    created(){
      const user = JSON.parse(localStorage.getItem('app.currentUser'));
      this.account = {
        first_name: user.contact_first_name ? `${user.contact_first_name}` : `${user.first_name}`,
        last_name: user.contact_last_name ? `${user.contact_last_name}` : `${user.last_name}`,
      }
      const token = localStorage.getItem('app.currentUser.token');
      // if (token) {
      //   this.$store.commit('auth/UPDATE_TOKEN', token)
      //   this.$store.commit('auth/UPDATE_LOGIN_STATUS', true)
      // }

      const splittedUrl = window.location.pathname.split('/') // ["", "business", "reminders"]
      this.userType = splittedUrl[1]
    },
    data() {
      return {
        account: {
          first_name: '',
          last_name: ''
        },
        userType: ''
      }
    },
    methods: {
      ...mapActions({
        signOut: 'auth/signOut',
      }),
      signOut() {
        this.signOut()
          .then(response => console.log(response))
          .catch(error => console.error(error))
      },
      openLink (value) {
        if(value === 'documents') this.$store.commit('changeSidebar', 'documents')
        if(value !== 'documents') this.$store.commit('changeSidebar', 'default')
      }
    },
    computed: {
      // ...mapGetters({
      //   currentUser: 'auth/getUser',
      // }),
      loggedIn() {
        return this.$store.getters.loggedIn;
      },
      // specialist() {
      //   return {
      //     first_name: this.currentUser.contact_first_name ? `${this.currentUser.contact_first_name}` : `${this.currentUser.first_name}`,
      //     last_name: this.currentUser.contact_last_name ? `${this.currentUser.contact_last_name}` : `${this.currentUser.last_name}`,
      //   }
      // }
    },
  }
</script>

<style scoped>

</style>

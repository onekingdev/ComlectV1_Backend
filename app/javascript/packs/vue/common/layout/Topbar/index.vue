<template lang="pug">
  b-navbar.topbar.p-0(toggleable='sm')
    b-navbar-toggle(target='nav-collapse')
    b-collapse#nav-collapse.topbar-menu(is-nav)
      ul.topbar-menu__list
        li.nav-item.topbar-menu__item(@click="openLink('default')")
          router-link.topbar-menu__link(to='/business' active-class="active" exact) Home
        li.nav-item.topbar-menu__item(@click="openLink('documents')")
          router-link.topbar-menu__link(to='/business/file_folders' active-class="active") Documents
        li.nav-item.topbar-menu__item(@click="openLink('default')")
          router-link.topbar-menu__link(to='/business/reports/risks' active-class="active") Reports
        li.nav-item.topbar-menu__item.d-none
          a.topbar-menu__link(aria-current='page' href='#') Community
      // Right aligned nav items
      b-navbar-nav.align-items-center.ml-auto.topbar-right
        a.btn.btn-warning.topbar-right-btn__find(href='/business/specialists')  Find an Expert
        a.btn.topbar-right-btn__notify(href='/business/settings/notifications')
          ion-icon(name='notifications-outline')
        b-nav-item-dropdown.topbar-right-dropdown(right)
          // Using 'button-content' slot
          template(#button-content)
            UserAvatar.topbar-right-dropdown__avatar(:user="specialist" :sm="true")
            | {{ specialist.first_name }} {{ specialist.last_name }}
            ion-icon.topbar-right-dropdown__icon(name='chevron-down-outline')
          b-dropdown-item(@click="openLink('documents')")
            router-link(to='/business/settings' active-class="active") Settings
          b-dropdown-item(@click="signOut") Sign Out
        a.btn.topbar-right-btn__help(href="#")
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
      this.specialist = {
        first_name: user.contact_first_name ? `${user.contact_first_name}` : `${user.first_name}`,
        last_name: user.contact_last_name ? `${user.contact_last_name}` : `${user.last_name}`,
      }
      const token = localStorage.getItem('app.currentUser.token');
      // if (token) {
      //   this.$store.commit('auth/UPDATE_TOKEN', token)
      //   this.$store.commit('auth/UPDATE_LOGIN_STATUS', true)
      // }
    },
    data() {
      return {
        specialist: {
          first_name: '',
          last_name: ''
        }
      }
    },
    methods: {
      // ...mapActions({
      //   singOut: 'auth/singOut',
      // }),
      signOut() {
        localStorage.removeItem('app.currentUser');
        localStorage.removeItem('app.currentUser.token');

        // this.singOut()
        //   .then(response => console.log(response))
        //   .catch(error => console.error(error))
        fetch('/users/sign_out/force', {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': JSON.parse(localStorage.getItem('app.currentUser.token'))
          }
        })
          .then(response => response.json())
          .then(data => console.log(data));
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

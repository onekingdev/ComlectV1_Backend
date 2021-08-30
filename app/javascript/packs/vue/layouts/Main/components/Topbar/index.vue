<template lang="pug">
  .topbar
    .logo
      a.logo__link(href="/")
        // img.logo__img(src='@/assets/logo_wordmark.svg')
        img.logo__img.logo__img_small(src='@/assets/primary.svg' width="24" height="24")
    b-navbar.p-0(toggleable='lg')
      b-navbar-toggle.justify-content-center(target='nav-collapse')
        | Menu
        ion-icon.ml-2(name='chevron-down-outline')
      b-collapse#nav-collapse.topbar-menu(v-model="visible")
        ul.topbar-menu__list
          li.nav-item.topbar-menu__item(@click="openLink('default')")
            router-link.topbar-menu__link(:to='`/${userType}`' active-class="active" exact) Home
          li.nav-item.topbar-menu__item(v-if="userType === 'business'" @click="openLink('documents')")
            router-link.topbar-menu__link(:to='`/${userType}/file_folders`' active-class="active") Documents
          li.nav-item.topbar-menu__item(v-if="role !=='basic'" @click="openLink('reports')")
            router-link.topbar-menu__link(:to='`/${userType}/reports/organizations`' active-class="active") Reports
          li.nav-item.topbar-menu__item.d-none
            a.topbar-menu__link(aria-current='page' href='#') Community
          li.nav-item.topbar-menu__item.d-sm-none(v-if="userType !== 'specialist' && role !=='basic'" @click="openLink('default')")
            router-link.topbar-menu__link(:to='`/specialistmarketplace`' active-class="active") Find an Expert
          li.nav-item.topbar-menu__item.d-sm-none(v-if="userType === 'specialist'" @click="openLink('default')")
            router-link.topbar-menu__link(to='/job_board' active-class="active") Browse Projects
    // Right aligned nav items
    b-navbar-nav.flex-row.align-items-center.ml-auto
      router-link.btn.btn-warning.btn-topbar.btn-topbar_find(v-if="userType !== 'specialist' && role !=='basic'" :to='`/specialistmarketplace`') Find an Expert
      router-link.btn.btn-warning.btn-topbar.btn-topbar_find(v-if="userType === 'specialist'" :to='`/job_board`') Browse Projects
      router-link.btn.btn-topbar.btn-topbar_notify(:to='`/${userType}/settings/notification-center`')
        ion-icon(name='notifications-outline')
      b-nav-item-dropdown.topbar-right-dropdown.actions(right)
        // Using 'button-content' slot
        template(#button-content)
          UserAvatar.topbar-right-dropdown__avatar(:user="account" :sm="true")
          span.topbar-right-dropdown__name {{ account.first_name }} {{ account.last_name }}
          ion-icon.topbar-right-dropdown__icon(name='chevron-down-outline')
        li(v-if="activeContracts && activeContracts.length")
          .dropdown-item(@click="openSelectedBusiness(null)") Back
        li(v-if="activeContracts" v-for="(contract, idx) in  activeContracts" :key="idx")
          .dropdown-item(@click="openSelectedBusiness(contract)") {{ contract.business_name }}
        li(@click="openLink('documents')")
          router-link.dropdown-item(:to='`/${userType}/profile`' active-class="active") Profile
        b-dropdown-item(@click="signOut") Sign Out
      //a.btn.btn-topbar.btn-topbar_help.d-none(href="#")
      //  b-icon.mr-2( icon="question-circle-fill" aria-label="Help")
      //  | Help
</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import UserAvatar from '@/common/UserAvatar'

  const plans = ['basic', 'business', 'team']
  const roles = ['basic', 'trusted', 'admin']

  export default {
    name: "index",
    components: {
      UserAvatar
    },
    created(){
      window.addEventListener("resize", this.screenWidthChangeHandler);
      if (window.innerWidth < 1000) this.visible = false

      const user = JSON.parse(localStorage.getItem('app.currentUser'));
      this.account = {
        first_name: user.contact_first_name ? `${user.contact_first_name}` : `${user.first_name}`,
        last_name: user.contact_last_name ? `${user.contact_last_name}` : `${user.last_name}`,
      }
      // this.$store.commit('UPDATE_USER', user)
      const token = localStorage.getItem('app.currentUser.token');
      // if (token) {
      //   this.$store.commit('auth/UPDATE_TOKEN', token)
      //   this.$store.commit('auth/UPDATE_LOGIN_STATUS', true)
      // }

      // const splittedUrl = window.location.pathname.split('/') // ["", "business", "reminders"]
      // this.userType = splittedUrl[1]
    },
    destroyed() {
      window.removeEventListener("resize", this.screenWidthChangeHandler);
    },
    data() {
      return {
        visible: true,
        account: {
          first_name: '',
          last_name: ''
        },
        // userType: '',
        // businessMenu: {
        //   link: `/${this.userType}`,
        //   title: ''
        // },
        // specialistMenu: {
        //   link: '',
        //   title: ''
        // }
      }
    },
    methods: {
      screenWidthChangeHandler(e) {
        if (window.innerWidth <= 991.98) this.visible = false
        if (window.innerWidth > 991.98) this.visible = true
      },
      // ...mapActions({
      //   signOut: 'auth/signOut',
      // }),
      signOut() {
        // this.singOut()
        //   .then(response => console.log(response))
        //   .catch(error => console.error(error))
        fetch('/api/users/sign_out', {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': JSON.parse(localStorage.getItem('app.currentUser.token'))
          }
        })
          .then(response => response.json())
          .then(data => {
            localStorage.clear();
            window.location.href = `${window.location.origin}`
          })
          .catch(error => console.error(error))

        // this.$store.dispatch('signOut')
        //   .then(response => {
        //     console.log(response)
        //     window.location.href = `${window.location.origin}`
        //     // router.push('home')
        //   })
        //   .catch(error => console.error(error))
      },
      openLink (value) {
        if(value === 'reports') {
          this.$store.commit('changeSidebar', 'reports')
          return
        }
        if(value === 'documents') this.$store.commit('changeSidebar', 'documents')
        if(value !== 'documents') this.$store.commit('changeSidebar', 'default')
      },
      /**
       * When we logged in as Employee, we can opend dashboard as employee for Business account and see some features based on roles
       */
      openSelectedBusiness (business) {
        if (business) {
          localStorage.setItem('app.business_id', business.business_id)
          localStorage.setItem('app.currentUser.role', business.role)
          window.location.href = `/business`
        }
        if (!business) {
          localStorage.removeItem('app.business_id')
          localStorage.removeItem('app.currentUser.role')
          window.location.href = `/specialist`
        }
      }
    },
    computed: {
      ...mapGetters({
        // currentUser: 'auth/getUser',
        loggedIn: 'loggedIn',
        userType: 'userType',
        roles: 'roles/roles',
        role: 'roles/currentRole',
        plan: 'roles/currentPlan',
      }),
      // loggedIn() {
      //   return this.$store.getters.loggedIn;
      // },
      // specialist() {
      //   return {
      //     first_name: this.currentUser.contact_first_name ? `${this.currentUser.contact_first_name}` : `${this.currentUser.first_name}`,
      //     last_name: this.currentUser.contact_last_name ? `${this.currentUser.contact_last_name}` : `${this.currentUser.last_name}`,
      //   }
      // }
      // userType () {
      //   return this.$store.getters.userType
      // },

      /**
       * It's current active roles (employee attached to Business account and has Roles
       */
      activeContracts () {
        return this.roles
      }
    },
    watch: {
      '$route' () {
        if(window.innerWidth < 992) {
          this.visible = false
        }
        // document.getElementById('nav-collapse').classList.remove('show')
        // $('#nav-collapse').collapse('hide')
      }
    }
  }
</script>

<style scoped>

</style>

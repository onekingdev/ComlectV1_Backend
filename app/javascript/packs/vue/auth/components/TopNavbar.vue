<template lang="pug">
  .row
    .col
      nav.navbar.navbar-expand-lg.navbar-light.p-0
        #top_navbar.collapse.navbar-collapse.d-flex.justify-content-between
          .logo
            a.logo__link(href="/")
              img.logo__img(src='@/assets/logo_wordmark.svg')
          .navbar-nav
            .dropdown.dropdown-profile(v-if="loggedIn")
              .dropdown-profile__btn(@click="isProfileMenuOpen = !isProfileMenuOpen" :aria-expanded="isProfileMenuOpen")
                span {{ userName }}
                b-icon.m-l-1(icon="chevron-down")
              ul.dropdown-menu.dropdown-menu-right(aria-labelledby="profile_dropdown_btn" :class="{ show: isProfileMenuOpen }")
                li(@click="signOut") Sign Out
            .ml-auto.mt-auto.mb-auto(v-else)
              a.btn.btn-dark(href="/users/sign_in") Sign in
        // button.navbar-toggler.position-absolute.d-md-none.collapsed(type='button' data-toggle='collapse' data-target='#sidebarMenu' aria-controls='sidebarMenu' aria-expanded='false' aria-label='Toggle navigation')
        //   span.navbar-toggler-icon
</template>

<script>
    export default {
      props: ['userInfo'],
      created(){
        const token = localStorage.getItem('app.currentUser.token');
        if (token) {
          this.$store.commit('UPDATE_TOKEN', token)
          this.$store.commit('UPDATE_LOGIN_STATUS', true)
        }
      },
      data() {
        return {
          isProfileMenuOpen: false,
        }
      },
      methods: {
        signOut() {
          const accessTokenLocalStorage = localStorage.getItem('app.currentUser.token') ? localStorage.getItem('app.currentUser.token') : ''
          fetch('/api/users/sign_out', {
            method: 'DELETE',
            headers: {'Accept': 'application/json', 'Content-Type': 'application/json', 'Authorization': JSON.parse(accessTokenLocalStorage)},
          })
            .then(response => response.json())
            .then(data => {
              console.log(data)
              localStorage.removeItem('app.currentUser');
              localStorage.removeItem('app.currentUser.token');
              localStorage.removeItem('app.currentUser.userType');
              window.location.href = `${window.location.origin}`
            })
            .catch(error => console.error(error))

          // this.$store.dispatch('auth/signOut')
          //   .then(response => console.log(response))
          //   .catch(error => console.error(error))
        }
      },
      computed: {
        loggedIn() {
          return this.$store.getters.loggedIn;
        },
        currentUser() {
          return this.$store.getters.getUser;
        },
        userName() {
          return this.currentUser.contact_first_name ? `${this.currentUser.contact_first_name} ${this.currentUser.contact_last_name}` : `${this.currentUser.first_name} ${this.currentUser.last_name}`
        }
      },
    }
</script>

<style scoped>
  @import "../styles.css";
</style>

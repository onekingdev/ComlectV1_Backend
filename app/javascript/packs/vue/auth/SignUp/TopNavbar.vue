<template lang="pug">
  .row
    .col
      nav.navbar.navbar-expand-lg.navbar-light.p-0
        #top_navbar.collapse.navbar-collapse.d-flex.justify-content-between
          .logo
            a.logo__link(href="/")
              img.logo__img(height='48px' src='/assets/logo-b7915ac667f29762d6d3745cf555b7d2c80bf3cd90b798a32385bdf9106dc870.png' style="vertical-align: middle; margin: 8px;")
          .navbar-nav.align-items-center
            .dropdown#profile_dropdown.p-x-1.p-x-md-2(v-if="loggedIn")
              #profile_dropdown_btn(@click="isProfileMenuOpen = !isProfileMenuOpen" :aria-expanded="isProfileMenuOpen")
                span {{ userName }}
                b-icon.m-l-1(icon="chevron-down")
                <!--ion-icon.m-l-1(name='chevron-down-outline' size="small")-->
              ul.dropdown-menu.dropdown-menu-right(aria-labelledby="profile_dropdown_btn" :class="{ show: isProfileMenuOpen }")
                li
                  a.dropdown-item(href="#") Edit Profile
                li(@click="signOut")
                  form(method="POST" action="/users/sign_out")
                        input(type="hidden" name="authenticity_token" value=form_authenticity_token)
                        input(type="hidden" name="_method" value="delete")
                        input.dropdown-item(type="submit" value="Sign Out")
            .p-x-2(v-else)
              a.btn.btn-dark(href="/users/sign_in") Sign in
        <!--button.navbar-toggler.position-absolute.d-md-none.collapsed(type='button' data-toggle='collapse' data-target='#sidebarMenu' aria-controls='sidebarMenu' aria-expanded='false' aria-label='Toggle navigation')-->
          <!--span.navbar-toggler-icon-->
</template>

<script>
    export default {
      props: ['userInfo'],
      created(){
        const token = localStorage.getItem('app.currentUser.token');
        if (token) {
          this.$store.commit('updateToken', token)
          this.$store.commit('loggedIn', true)
        }
      },
      data() {
        return {
          isProfileMenuOpen: false,
        }
      },
      methods: {
        signOut() {
          localStorage.removeItem('app.currentUser');
          localStorage.removeItem('app.currentUser.token');
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

<template lang="pug">
  .row
    .col
      nav.navbar.navbar-expand-lg.navbar-light.p-0
        #top_navbar.collapse.navbar-collapse.d-flex.justify-content-between
          img(height='48px' src='/assets/logo-b7915ac667f29762d6d3745cf555b7d2c80bf3cd90b798a32385bdf9106dc870.png' style="vertical-align: middle; margin: 8px;")
          .navbar-nav.align-items-center
            .dropdown#profile_dropdown.p-x-2(v-if="logIn")
              #profile_dropdown_btn(@click="isProfileMenuOpen = !isProfileMenuOpen" :aria-expanded="isProfileMenuOpen")
                ion-icon.m-l-1(name='chevron-down-outline')
              ul.dropdown-menu.dropdown-menu-right(aria-labelledby="profile_dropdown_btn" :class="{ show: isProfileMenuOpen }")
                li
                  a.dropdown-item(href="#") Edit Profile
                li
                  form(method="POST" action="destroy_user_session_path")
                    input(type="hidden" name="authenticity_token" value=form_authenticity_token)
                    input(type="hidden" name="_method" value="delete")
                    input.dropdown-item(type="submit" value="Sign Out")
            .p-x-2(v-else)
              a.btn.btn-dark(href="/users/sign_in") Log in
        button.navbar-toggler.position-absolute.d-md-none.collapsed(type='button' data-toggle='collapse' data-target='#sidebarMenu' aria-controls='sidebarMenu' aria-expanded='false' aria-label='Toggle navigation')
          span.navbar-toggler-icon
</template>

<script>
    export default {
      data() {
        return {
          isProfileMenuOpen: false,
        }
      },
      computed: {
        logIn() {
          return this.$store.getters.logIn;
        },
      },
    }
</script>

<style scoped>

</style>

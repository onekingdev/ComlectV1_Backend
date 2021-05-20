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
        button.navbar-toggler.position-absolute.d-md-none.collapsed(type='button' data-toggle='collapse' data-target='#sidebarMenu' aria-controls='sidebarMenu' aria-expanded='false' aria-label='Toggle navigation')
          span.navbar-toggler-icon
      nav.navbar.navbar-expand-lg.navbar-light.p-0.d-none
        .navbar-header
          button.navbar-toggle.collapsed(aria-expanded='false' data-target='#navbar-collapse' data-toggle='collapse' type='button')
            span.sr-only Toggle navigataion
            svg#dots-horizontal-icon--even(style='color: #000; width: 25px; height: 7px;' viewBox='0 0 25 7')
              circle(cx='3.5' cy='3.5' r='2.5')
              circle(cx='12.5' cy='3.5' r='2.5')
              circle(cx='21.5' cy='3.5' r='2.5')
          a.navbar-brand(href='https://www.complect.com/' target='_blank')
            img(height='48px' src='/assets/logo-b7915ac667f29762d6d3745cf555b7d2c80bf3cd90b798a32385bdf9106dc870.png')
          .nav-dropdown
            button.nav-dropbtn Products
            .nav-dropdown-content(style='width: 850px;')
              .col(style='width: 280px;')
                h3 Mission
                a(target='_blank' href='https://www.complect.com/about-us') About Us
                p Built by compliance for compliance
              .col(style='width: 300px;')
                h3 Products
                a(target='_blank' href='https://www.complect.com/#comp-kdok9b3r') Compliance Command Center
                p One tool to rule them all
                a(target='_blank' href='https://www.complect.com/#comp-kdok9xtp') Marketplace
                p Compliance specialists on demand
                a(target='_blank' href='https://www.complect.com/#comp-kdokb3hw') Turnkey Consulting Suite
                p 360 support for solo specialists and boutique firms
              .col(style='width: 200px;')
                h3 Support
                a(target='_blank' href='https://www.complect.com/faqs') FAQs
                a(target='_blank' href='https://calendly.com/complect') Demo
          .nav-dropdown
            button.nav-dropbtn Resources
            .nav-dropdown-content(style='width: 690px;')
              .col(style='width: 250px;')
                h3 Insights
                a(target='_blank' href='https://www.complect.com/the-guide') The Guide
                p Our blog on all things financial regulatory compliance
              .col(style='width: 260px;')
                h3 Events
                a(target='_blank' href='https://www.complect.com/compliance-connect-2021') Compliance Connect 2021
                p Learn how to optimize your business, compliantly
              .col(style='width: 130px;')
                h3 Security
                a(target='_blank' href='https://www.complect.com/security') Security
          a.nav-dropbtn(target='_blank' href='https://www.complect.com/pricing') Pricing

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

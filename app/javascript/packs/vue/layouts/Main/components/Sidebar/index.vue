<template lang="pug">
  nav.sidebar-menu(v-if="leftSidebar !== 'settings' || leftSidebar !== 'builder'" :class="[{ menuClosed: toggleClosedMenu }, leftSidebar==='builder' ? 'd-none' : '']")
    div.sidebar-menu__central(v-if="leftSidebar === 'default' || userType === 'specialist'")
      h3.sidebar-menu__title(
      :class="overview_collapse ? null : 'collapsed'"
      :aria-expanded="overview_collapse ? 'true' : 'false'"
      aria-controls="overview_collapse"
      @click="menuToggle('overview_collapse')")
        ion-icon(name='list-outline')
        span Overview
        ion-icon.ml-auto(name='chevron-down-outline')
      b-collapse#overview_collapse(v-model="overview_collapse")
        ul.sidebar-menu__list
          li.nav-item.sidebar-menu__item(v-for="(link, i) in menuLinksOverview" @click.stop="openLink('default')" :key="i")
            router-link.sidebar-menu__link(:to='link.to' active-class="active" :exact="link.exact || false")
              | {{ link.label }}
      div(v-if="userType !== 'specialist'")
        h3.sidebar-menu__title(
        :class="program_management_collapse ? null : 'collapsed'"
        :aria-expanded="program_management_collapse ? 'true' : 'false'"
        aria-controls="program_management_collapse"
        @click="menuToggle('program_management_collapse')"
        )
          ion-icon(name='document-text-outline')
          span Program Management
          ion-icon.ml-auto(name='chevron-down-outline')
        b-collapse#program_management_collapse(v-model="program_management_collapse")
          ul.sidebar-menu__list
            li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/compliance_policies`' active-class="active")
                | Policies and Procedures
            li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/annual_reviews`' active-class="active")
                | Internal Review
            li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/risks`' active-class="active")
                | Risk Register
      div(class="dropdown-divider")
      router-link.sidebar-menu__link.sidebar-menu__link_settings(:to='`/${userType}/settings`' active-class="active")
        h3.sidebar-menu__title.sidebar-menu__title_settings
          ion-icon(name='settings-outline' @click.stop="openLink('settings')")
          span Settings
    div.sidebar-menu__central(v-if="userType !== 'specialist' && leftSidebar === 'documents'")
     h3.sidebar-menu__title(
     :class="files ? null : 'collapsed'"
     :aria-expanded="files ? 'true' : 'false'"
     aria-controls="files"
     @click="menuToggle('files')"
     )
      ion-icon(name='document-text-outline')
      span Files
      ion-icon.ml-auto(name='chevron-down-outline')
     b-collapse#files(v-model="files")
       ul.sidebar-menu__list
         li.nav-item.sidebar-menu__item(@click.stop="openLink('documents')")
           router-link.sidebar-menu__link(:to='`/${userType}/file_folders`' active-class="active" exact)
             | Book and records
         li.nav-item.sidebar-menu__item(@click.stop="openLink('documents')")
           router-link.sidebar-menu__link(:to='`/${userType}/exam_management`' active-class="active")
             | Exam Management
     div(class="dropdown-divider")
     router-link.sidebar-menu__link.sidebar-menu__link_settings(:to='`/${userType}/settings`' active-class="active")
        h3.sidebar-menu__title.sidebar-menu__title_settings
          ion-icon(name='settings-outline' @click.stop="openLink('settings')")
          span Settings
    div.sidebar-menu__central(v-if="userType === 'business' && leftSidebar === 'reports'")
      h3.sidebar-menu__title(
      :class="reports ? null : 'collapsed'"
      :aria-expanded="reports ? 'true' : 'false'"
      aria-controls="reports"
      @click="menuToggle('reports')"
      )
        ion-icon(name='document-text-outline')
        span Reports
        ion-icon.ml-auto(name='chevron-down-outline')
      b-collapse#reports(v-model="reports")
        ul.sidebar-menu__list
          li.nav-item.sidebar-menu__item(@click.stop="openLink('reports')")
            router-link.sidebar-menu__link(:to='`/${userType}/reports/organizations`' active-class="active" exact)
              | Organization
          li.nav-item.sidebar-menu__item(@click.stop="openLink('reports')")
            router-link.sidebar-menu__link(:to='`/${userType}/reports/risks`' active-class="active")
              | Risks
          li.nav-item.sidebar-menu__item(@click.stop="openLink('reports')")
            router-link.sidebar-menu__link(:to='`/${userType}/reports/financials`' active-class="active")
              | Financials
      div(class="dropdown-divider")
      router-link.sidebar-menu__link.sidebar-menu__link_settings(:to='`/${userType}/settings`' active-class="active")
        h3.sidebar-menu__title.sidebar-menu__title_settings
          ion-icon(name='settings-outline' @click.stop="openLink('settings')")
          span Settings
    div(class="dropdown-divider")
    button.sidebar-menu__btn(@click="toggleClosedMenu = !toggleClosedMenu")
      span Collapse menu
      div( :class="!toggleClosedMenu ? 'flip-horizontal' : ''")
        ion-icon(name="log-in-outline")
</template>

<script>
  export default {
    data() {
      return {
        overview_collapse: true,
        program_management_collapse: true,
        files: true,
        reports: true,
        toggleClosedMenu: false
      }
    },
    created() {
      this.$store.commit('changeUserType', this.userType)
    },
    methods: {
      openLink (value) {
        if(window.innerWidth < 576) {
          this.overview_collapse = true
          this.program_management_collapse = true
          this.files = true
          this.toggleClosedMenu = false
        }
        if(value === 'settings') {
          this.$store.commit('changeSidebar', 'settings')
          return
        }
        if(value === 'reports') {
          this.$store.commit('changeSidebar', 'reports')
          return
        }
        if(value === 'documents') this.$store.commit('changeSidebar', 'documents')
        if(value !== 'documents') this.$store.commit('changeSidebar', 'default')
      },
      menuToggle(value) {
        if(window.innerWidth < 576) {
          this.toggleClosedMenu = !this.toggleClosedMenu
          this[value] = true
          return
        }
        this[value] = !this[value]
      },
      checkRouteAndChangeSidebar() {
        if(window.innerWidth < 576) {
          this.overview_collapse = false
          this.program_management_collapse = false
          this.files = false
        }

        const routeName = this.$route.name

        if(
          routeName === "settings-general" ||
          routeName === "settings-users" ||
          routeName === "settings-roles" ||
          routeName === "settings-security" ||
          routeName === "settings-subscriptions" ||
          routeName === "settings-billings" ||
          routeName === "settings-notifications" ||
          routeName === "settings-notification-center" ||
          routeName === "specialists-marketplace" ||
          routeName === "profile" ||
          routeName === "settings-specialist" ||
          routeName === "settings-general-specialist" ||
          routeName === "settings-users-specialist" ||
          routeName === "settings-roles-specialist" ||
          routeName === "settings-security-specialist" ||
          routeName === "settings-subscriptions-specialist" ||
          routeName === "settings-billings-specialist" ||
          routeName === "settings-notifications-specialist"
        ) {
          this.$store.commit('changeSidebar', 'builder')
          // document.querySelector('.sidebar-menu').style.display = "none"
          return
        }

        if(routeName === "policy-current" || routeName === "settings") {
          this.$store.commit('changeSidebar', 'builder')
          // document.querySelector('.sidebar-menu').style.display = "none"
          return
        }

        if(routeName === "reports"|| routeName === "reports-risks" || routeName === "reports-organizations" || routeName === "reports-financials") {
          this.$store.commit('changeSidebar', 'reports')
          // document.querySelector('.sidebar-menu').style.display = "none"
          return
        }

        // document.querySelector('.sidebar-menu').style.display = "flex"
        if(routeName === "file-folders"
          || routeName === "exam-management"
          || routeName === "exam-management-current-review"
          || routeName === "settings"
          || routeName === "settings-notification-center"
        ) this.$store.commit('changeSidebar', 'documents')
        // if(routeName !== "file-folders") this.$store.commit('changeSidebar', 'default')

      }
    },
    computed: {
      leftSidebar () {
        return this.$store.getters.leftSidebar
      },
      userType() {
        const splittedUrl = window.location.pathname.split('/') // ["", "business", "reminders"]
        return splittedUrl[1] === 'business' ? 'business' : 'specialist'
      },
      menuLinksOverview() {
        return this.userType === 'business' ? this.menuLinksOverviewBusiness : this.menuLinksOverviewSpecialist
      },
      menuLinksOverviewBusiness() {
        return [{
          to: '/business',
          label: 'Dashboard',
          exact: true
        }, {
          to: '/business/reminders',
          label: 'Tasks'
        }, {
          to: '/business/projects',
          label: 'Projects'
        }]
      },
      menuLinksOverviewSpecialist() {
        return [{
          to: '/specialist',
          label: 'Dashboard',
          exact: true
        }, {
          to: '/specialist/reminders',
          label: 'Tasks'
        }, {
          to: '/specialist/my-projects',
          label: 'Projects'
        }]
      },
    },
    mounted() {
      this.checkRouteAndChangeSidebar()
    },
    watch: {
      '$route' () {
        this.checkRouteAndChangeSidebar()
      }
    }
  }
</script>

<style scoped>

</style>

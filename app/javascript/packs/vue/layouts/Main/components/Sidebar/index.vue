<template lang="pug">
  nav.sidebar-menu(v-if="leftSidebar !== 'settings' || leftSidebar !== 'builder'" :class="{ menuClosed: toggleClosedMenu }")
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
          li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}`' active-class="active" exact)
              | Dashboard
          li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}/reminders`' active-class="active")
              | Tasks
          li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}/projects`' active-class="active")
              | Projects
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
                | Annual Review
            li.nav-item.sidebar-menu__item(@click.stop="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/risks`' active-class="active")
                | Risk Register
      div(class="dropdown-divider")
      router-link.sidebar-menu__link(:to='`/${userType}/settings`' active-class="active")
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
     router-link.sidebar-menu__link(:to='`/${userType}/settings`' active-class="active")
        h3.sidebar-menu__title.sidebar-menu__title_settings
          ion-icon(name='settings-outline' @click.stop="openLink('settings')")
          span Settings
    div(class="dropdown-divider")
    button.sidebar-menu__btn(@click="toggleClosedMenu = !toggleClosedMenu")
      span Collapse menu
      ion-icon(:name="!toggleClosedMenu ? 'arrow-back-circle-outline' : 'arrow-forward-circle-outline'")
</template>

<script>
  export default {
    data() {
      return {
        overview_collapse: true,
        program_management_collapse: true,
        files: true,
        userType: '',
        toggleClosedMenu: false
      }
    },
    created() {
      const splittedUrl = window.location.pathname.split('/') // ["", "business", "reminders"]
      this.userType = splittedUrl[1]
      this.$store.commit('changeUserType', this.userType)
      const splitUrl = splittedUrl[2]
      if(splitUrl === "file_folders" || splitUrl === "settings") this.$store.commit('changeSidebar', 'documents')
      if(splitUrl !== "file_folders") this.$store.commit('changeSidebar', 'default')
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
      }
    },
    computed: {
      leftSidebar () {
        return this.$store.getters.leftSidebar
      }
    },
    watch: {
      '$route' () {
        if(window.innerWidth < 576) {
          this.overview_collapse = false
          this.program_management_collapse = false
          this.files = false
        }

        const splitUrl = this.$route.name
        if(splitUrl === "policy-current") {
          this.$store.commit('changeSidebar', 'builder')
          document.querySelector('.sidebar-menu').style.display = "none"
          return
        }

        document.querySelector('.sidebar-menu').style.display = "flex"
        if(splitUrl === "file-folders"
          || splitUrl === "settings"
          || splitUrl === "settings-notification-center") this.$store.commit('changeSidebar', 'documents')
        if(splitUrl !== "file-folders") this.$store.commit('changeSidebar', 'default')
      }
    }
  }
</script>

<style scoped>

</style>

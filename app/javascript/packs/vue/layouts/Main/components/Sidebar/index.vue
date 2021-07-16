<template lang="pug">
  nav.sidebar-menu(v-if="leftSidebar !== 'settings'" :class="{ menuClosed: toggleClosedMenu }")
    div.sidebar-menu__central(v-if="leftSidebar === 'default' || userType === 'specialist'")
      h3.sidebar-menu__title(role="button" v-b-toggle.overview_collapse="true" @click="toggleClosedMenu = false")
        ion-icon(name='list-outline')
        span Overview
        ion-icon.ml-auto(name='chevron-down-outline')
      b-collapse#overview_collapse(:visible="true")
        ul.sidebar-menu__list
          li.nav-item.sidebar-menu__item(@click="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}`' active-class="active" exact)
              | Dashboard
          li.nav-item.sidebar-menu__item(@click="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}/reminders`' active-class="active")
              | Tasks
          li.nav-item.sidebar-menu__item(@click="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}/projects`' active-class="active")
              | Projects
      div(v-if="userType !== 'specialist'")
        h3.sidebar-menu__title(role="button" v-b-toggle.program_management_collapse="true" @click="toggleClosedMenu = false")
          ion-icon(name='document-text-outline')
          span Program Management
          ion-icon.ml-auto(name='chevron-down-outline')
        b-collapse#program_management_collapse(:visible="true")
          ul.sidebar-menu__list
            li.nav-item.sidebar-menu__item(@click="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/compliance_policies`' active-class="active")
                | Policies and Procedures
            li.nav-item.sidebar-menu__item(@click="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/annual_reviews`' active-class="active")
                | Annual Review
            li.nav-item.sidebar-menu__item(@click="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/risks`' active-class="active")
                | Risk Register
      div(class="dropdown-divider")
      router-link.sidebar-menu__link(:to='`/${userType}/settings`' active-class="active")
        h3.sidebar-menu__title.sidebar-menu__title_settings
          ion-icon(name='settings-outline' @click="openLink('settings')")
          span Settings
    div.sidebar-menu__central(v-if="userType !== 'specialist' && leftSidebar === 'documents'")
     h3.sidebar-menu__title(role="button" v-b-toggle.files="")
      ion-icon(name='document-text-outline')
      span Files
      ion-icon.ml-auto(name='chevron-down-outline')
     b-collapse#files(:visible="true")
       ul.sidebar-menu__list
         li.nav-item.sidebar-menu__item(@click="openLink('documents')")
           router-link.sidebar-menu__link(:to='`/${userType}/file_folders`' active-class="active" exact)
             | Book and records
         li.nav-item.sidebar-menu__item(@click="openLink('documents')")
           router-link.sidebar-menu__link(:to='`/${userType}/exam_management`' active-class="active")
             | Exam Management
     div(class="dropdown-divider")
     router-link.sidebar-menu__link(:to='`/${userType}/settings`' active-class="active")
        h3.sidebar-menu__title.sidebar-menu__title_settings
          ion-icon(name='settings-outline' @click="openLink('settings')")
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
      if(splitUrl !== "file_folders" || splitUrl !== "settings") this.$store.commit('changeSidebar', 'default')
    },
    methods: {
      openLink (value) {
        if(value === 'settings') {
          this.$store.commit('changeSidebar', 'settings')
          return
        }
        if(value === 'documents') this.$store.commit('changeSidebar', 'documents')
        if(value !== 'documents') this.$store.commit('changeSidebar', 'default')
      }
    },
    computed: {
      leftSidebar () {
        return this.$store.getters.leftSidebar
      }
    }
  }
</script>

<style scoped>

</style>

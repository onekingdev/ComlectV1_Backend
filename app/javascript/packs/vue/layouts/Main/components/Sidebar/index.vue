<template lang="pug">
  nav.sidebar-menu(v-if="leftSidebar !== 'settings'" :class="{ mobileMenu: toggleMobileMenu }")
    //.logo
    //  a.logo__link(href="/")
    //    img.logo__img(src="/assets/logo-2-white.png" width="81px")
    div.sidebar-menu__central(v-if="leftSidebar === 'default' || userType === 'specialist'")
      h3.sidebar-menu__title(role="button" v-b-toggle.overview_collapse="")
        ion-icon(name='list-outline')
        span(v-if="!toggleMobileMenu") Overview
        ion-icon.ml-auto(name='chevron-down-outline')
      b-collapse#overview_collapse(:visible="true")
        ul.sidebar-menu__list
          li.nav-item.sidebar-menu__item(@click="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}`' active-class="active" exact)
              //ion-icon(name='globe-outline')
              | Dashboard
          li.nav-item.sidebar-menu__item(@click="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}/reminders`' active-class="active")
              //ion-icon(name='checkbox-outline')
              | Tasks
          li.nav-item.sidebar-menu__item(@click="openLink('default')")
            router-link.sidebar-menu__link(:to='`/${userType}/projects`' active-class="active")
              //ion-icon(name='list-outline')
              | Projects
      div(v-if="userType !== 'specialist'")
        h3.sidebar-menu__title(role="button" v-b-toggle.program_management_collapse="")
          ion-icon(name='document-text-outline')
          span(v-if="!toggleMobileMenu") Program Management
          ion-icon.ml-auto(name='chevron-down-outline')
        b-collapse#program_management_collapse(:visible="true")
          ul.sidebar-menu__list
            li.nav-item.sidebar-menu__item(@click="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/compliance_policies`' active-class="active")
                //ion-icon(name='newspaper-outline')
                | Policies and Procedures
            li.nav-item.sidebar-menu__item(@click="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/annual_reviews`' active-class="active")
                //ion-icon(name='document-text-outline')
                | Annual Review
            li.nav-item.sidebar-menu__item(@click="openLink('default')")
              router-link.sidebar-menu__link(:to='`/${userType}/risks`' active-class="active")
                //ion-icon(name='warning-outline')
                | Risk Register
      //.sidebar-menu__separator
      div
        div(class="dropdown-divider")
        li.nav-item.sidebar-menu__item(@click="openLink('settings')")
          router-link.sidebar-menu__link(:to='`/${userType}/settings`' active-class="active")
            ion-icon(name='settings-outline')
            | Settings
    div.sidebar-menu__central(v-if="userType !== 'specialist' && leftSidebar === 'documents'")
     h3.sidebar-menu__title(role="button" v-b-toggle.files="")
      ion-icon(name='document-text-outline')
      span(v-if="!toggleMobileMenu") Files
      ion-icon.ml-auto(name='chevron-down-outline')
     b-collapse#files(:visible="true")
       ul.sidebar-menu__list
         li.nav-item.sidebar-menu__item(@click="openLink('documents')")
           router-link.sidebar-menu__link(:to='`/${userType}/file_folders`' active-class="active" exact)
             //ion-icon(name='folder-outline')
             | Book and records
         li.nav-item.sidebar-menu__item(@click="openLink('documents')")
           router-link.sidebar-menu__link(:to='`/${userType}/exam_management`' active-class="active")
             //ion-icon(name='search-outline')
             | Exam Management
         div(class="dropdown-divider")
         li.nav-item.sidebar-menu__item(@click="openLink('settings')")
           router-link.sidebar-menu__link(:to='`/${userType}/settings`' active-class="active")
             ion-icon(name='settings-outline')
             | Settings
    //.sidebar-menu__separator
    div(class="dropdown-divider")
    button.sidebar-menu__btn(@click="toggleMobileMenu = !toggleMobileMenu")
      span(v-if="!toggleMobileMenu") Collapse menu
      ion-icon(:name="!toggleMobileMenu ? 'arrow-back-circle-outline' : 'arrow-forward-circle-outline'")
</template>

<script>
  export default {
    data() {
      return {
        userType: '',
        toggleMobileMenu: false
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

<template lang="pug">
  nav#sidebarMenu.col-md-3.col-lg-2.d-md-block.sidebar.collapse.px-0
    h3.d-flex.justify-content-between(role="button" v-b-toggle.overview_collapse="")
      | Overview
      ion-icon(name='chevron-down-outline')
    b-collapse#overview_collapse(:visible="true")
      ul.nav.flex-column
        li.nav-item
          a.btn(aria-current='page' href='/business')
            ion-icon(name='globe-outline')
            | Dashboard
        li.nav-item
          a.btn(aria-current='page' href='/business/projects')
            ion-icon(name='list-outline')
            | Projects
        li.nav-item
          a.btn(aria-current='page' href='/business/reminders')
            ion-icon(name='checkbox-outline')
            | Tasks

    h3.d-flex.justify-content-between(role="button" v-b-toggle.program_management_collapse="")
      | Program Management
      ion-icon(name='chevron-down-outline')
    b-collapse#program_management_collapse(:visible="true")
      ul.nav.flex-column
        li.nav-item
          a.btn(aria-current='page' href='/business/compliance_policies')
            ion-icon(name='newspaper-outline')
            | Policies and Procedures
        li.nav-item
          a.btn(aria-current='page' href='/business/annual_reviews')
            ion-icon(name='document-text-outline')
            | Annual Review
        li.nav-item
          a.btn(aria-current='page' href='/business/risks')
            ion-icon(name='warning-outline')
            | Risk Register

    h3.d-flex.justify-content-between(role="button" v-b-toggle.addons_collapse="")
      | Add-ons
      ion-icon(name='chevron-down-outline')
    b-collapse#addons_collapse(:visible="true")
      ul.nav.flex-column
        li.nav-item
          a.btn(aria-current='page' href='#')
            ion-icon(name='layers-outline')
            | My Add-Ons
        li.nav-item
          a.btn(aria-current='page' href='#')
            ion-icon(name='storefront-outline')
            | Add-On Marketplace
        li.nav-item
          a.btn(aria-current='page' href='#')
            ion-icon(name='settings-outline')
            | Settings
    h3.d-flex.justify-content-between(role="button" v-b-toggle.files="")
      | Files
      ion-icon(name='chevron-down-outline')
    b-collapse#files(:visible="true")
      ul.nav.flex-column
        li.nav-item
          a.btn(aria-current='page' href='/business/file_folders')
            ion-icon(name='folder-outline')
            | Book and records
        li.nav-item
          a.btn(aria-current='page' href='/business/exam_management')
            ion-icon(name='search-outline')
            | Exam Management
        li.nav-item
          a.btn(aria-current='page' href='#')
            ion-icon(name='settings-outline')
            | Settings
</template>

<script>
  export default {
      name: "index"
  }
</script>

<style scoped>
  #sidebarMenu {
    background-color: black;
  }
  .fixed-top {
    background-color: black;
  }
</style>

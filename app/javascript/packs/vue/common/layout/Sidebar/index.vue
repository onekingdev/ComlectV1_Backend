<template lang="pug">
  nav.sidebar-menu
    .logo
      a.logo__link(href="/")
        img.logo__img(src="/assets/logo-2-white.png" width="81px")
    h3.sidebar-menu__title.d-flex.justify-content-between(role="button" v-b-toggle.overview_collapse="")
      | Overview
      ion-icon(name='chevron-down-outline')
    b-collapse#overview_collapse(:visible="true")
      ul.sidebar-menu__list
        li.nav-item.sidebar-menu__item
          a.sidebar-menu__link(aria-current='page' href='/business')
            ion-icon(name='globe-outline')
            | Dashboard
        li.nav-item.sidebar-menu__item
          a.sidebar-menu__link(aria-current='page' href='/business/projects')
            ion-icon(name='list-outline')
            | Projects
        li.nav-item.sidebar-menu__item
          a.sidebar-menu__link(aria-current='page' href='/business/reminders')
            ion-icon(name='checkbox-outline')
            | Tasks

    h3.sidebar-menu__title.d-flex.justify-content-between(role="button" v-b-toggle.program_management_collapse="")
      | Program Management
      ion-icon(name='chevron-down-outline')
    b-collapse#program_management_collapse(:visible="true")
      ul.sidebar-menu__list
        li.nav-item.sidebar-menu__item
          a.sidebar-menu__link(aria-current='page' href='/business/compliance_policies')
            ion-icon(name='newspaper-outline')
            | Policies and Procedures
        li.nav-item.sidebar-menu__item
          a.sidebar-menu__link(aria-current='page' href='/business/annual_reviews')
            ion-icon(name='document-text-outline')
            | Annual Review
        li.nav-item.sidebar-menu__item
          a.sidebar-menu__link(aria-current='page' href='/business/risks')
            ion-icon(name='warning-outline')
            | Risk Register

    // h3.sidebar-menu__title.d-flex.justify-content-between(role="button" v-b-toggle.files="")
    //   | Files
    //   ion-icon(name='chevron-down-outline')
    // b-collapse#files(:visible="true")
    //   ul.sidebar-menu__list
    //     li.nav-item.sidebar-menu__item
    //       a.sidebar-menu__link(aria-current='page' href='/business/file_folders')
    //         ion-icon(name='folder-outline')
    //         | Book and records
    //     li.nav-item.sidebar-menu__item
    //       a.sidebar-menu__link(aria-current='page' href='/business/exam_management')
    //         ion-icon(name='search-outline')
    //         | Exam Management
    //     li.nav-item.sidebar-menu__item
    //       a.sidebar-menu__link(aria-current='page' href='#')
    //         ion-icon(name='settings-outline')
    //         | Settings
</template>

<script>
  export default {

  }
</script>

<style scoped>

</style>

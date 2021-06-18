<template lang="pug">
  b-navbar.topbar.p-0(toggleable='sm')
    b-navbar-toggle(target='nav-collapse')
    b-collapse#nav-collapse.topbar-menu(is-nav)
      b-navbar-nav.topbar-menu__list(class="align-items-center")
        b-nav-item.topbar-menu__item(href='/') Home
        b-nav-item.topbar-menu__item(href='/business/file_folders') Documents
        b-nav-item.topbar-menu__item(href='/business/reports/risks') Reports
        b-nav-item.topbar-menu__item.d-none(href='#') Community
      // Right aligned nav items
      b-navbar-nav.align-items-center.ml-auto
        a.btn.btn-warning.mr-2(href='/business/specialists')  Find an Expert
        a.btn.btn-default.mr-2(href='/business/settings/notifications')
          ion-icon(name='notifications-outline')
        b-nav-item-dropdown(right)
          // Using 'button-content' slot
          template(#button-content)
            UserAvatar.mx-1(:user="specialist")
            | {{ specialist.first_name }} {{ specialist.last_name }}
            ion-icon.mx-1(name='chevron-down-outline')
          b-dropdown-item(href='/business/settings') Settings
          b-dropdown-item(href='#') Sign Out
        a.btn.btn-default.px-1(href="#")
          b-icon.mr-2( icon="question-circle-fill" aria-label="Help")
          | Help
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  export default {
    name: "index",
    components: {
      UserAvatar
    },
    data() {
      return {
        isProfileMenuOpen: false,
        specialist: {
          first_name: 'Oscar',
          last_name: 'Handsome'
        }
      }
    }
  }
</script>

<style scoped>

</style>

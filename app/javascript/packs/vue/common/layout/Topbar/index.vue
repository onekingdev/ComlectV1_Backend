<template lang="pug">
  b-navbar.topbar.p-0(toggleable='sm')
    b-navbar-toggle(target='nav-collapse')
    b-collapse#nav-collapse.topbar-menu(is-nav)
      ul.topbar-menu__list
        li.nav-item.topbar-menu__item
          router-link.topbar-menu__link(to='/business' active-class="active" exact) Home
        li.nav-item.topbar-menu__item
          router-link.topbar-menu__link(to='/business/file_folders' active-class="active") Documents
        li.nav-item.topbar-menu__item
          router-link.topbar-menu__link(to='/business/reports/risks' active-class="active") Reports
        li.nav-item.topbar-menu__item.d-none
          a.topbar-menu__link(aria-current='page' href='#') Community
      // Right aligned nav items
      b-navbar-nav.align-items-center.ml-auto.topbar-right
        a.btn.btn-warning.topbar-right-btn__find(href='/business/specialists')  Find an Expert
        a.btn.topbar-right-btn__notify(href='/business/settings/notifications')
          ion-icon(name='notifications-outline')
        b-nav-item-dropdown.topbar-right-dropdown(right)
          // Using 'button-content' slot
          template(#button-content)
            UserAvatar.topbar-right-dropdown__avatar(:user="specialist" :sm="true")
            | {{ specialist.first_name }} {{ specialist.last_name }}
            ion-icon.topbar-right-dropdown__icon(name='chevron-down-outline')
          b-dropdown-item(href='/business/settings') Settings
          b-dropdown-item(href='#') Sign Out
        a.btn.topbar-right-btn__help(href="#")
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

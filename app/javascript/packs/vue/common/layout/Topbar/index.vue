<template lang="pug">
  div
    b-navbar.p-0(toggleable='lg' type='dark' variant='info')
      .logo
        a.logo__link(href="/")
          img.logo__img(src="/assets/logo-b7915ac667f29762d6d3745cf555b7d2c80bf3cd90b798a32385bdf9106dc870.png" width="216px")
      b-navbar-toggle(target='nav-collapse')
      b-collapse#nav-collapse(is-nav)
        b-navbar-nav(class="align-items-center")
          b-nav-item(href='/')
            ion-icon.mr-2(name='home-outline')
            | Home
          b-nav-item(href='/business/file_folders')
            ion-icon.mr-2(name='document-text-outline')
            | Documents
          b-nav-item(href='/business/reports/risks')
            ion-icon.mr-2(name='bar-chart-outline')
            | Reports
          b-nav-item.d-none(href='#')
            ion-icon.mr-2(name='people-outline')
            | Community
        // Right aligned nav items
        b-navbar-nav.align-items-center.ml-auto
          a.btn.btn-warning(href='/business/specialists')  Find an Expert
          a.btn.btn-default(href='/business/settings/notifications')
            ion-icon(name='notifications-outline')
          b-nav-item-dropdown(right)
            // Using 'button-content' slot
            template(#button-content)
              UserAvatar(:user="specialist")
              | {{ specialist.first_name }} {{ specialist.last_name }}
              ion-icon.ml-1(name='chevron-down-outline')
            b-dropdown-item(href='/business/settings') Settings
            b-dropdown-item(href='#') Sign Out
          a.btn.btn-default(href="#")
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

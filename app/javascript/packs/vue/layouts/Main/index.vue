<template lang="pug">
  .container-fluid.p-0
    Topbar
    .d-flex
      Sidebar
      .d-flex.flex-column.flex-grow-1
        main.wrapper#main-content.flex-grow-1
         router-view

    // <cui-sidebar />
    // top bar
    // left menu
    // comp
      // left menu mobile
      div(v-if='settings.isMobileView')
        div(:class='$style.handler' @click='toggleMobileMenu')
          div(:class='$style.handlerIcon')
        a-drawer(:closable='false' :visible='settings.isMobileMenuOpen' placement='left' :wrapClassName='$style.mobileMenu' @close='toggleMobileMenu')
          cui-menu-left
            // top menu
            // vty,
              cui-topbar
                cui-breadcrumbs
                  a-layout-content(style='height: '100%';  position: 'relative'')
                    div(class='cui__utils__content')
                      transition(:name='settings.routerAnimation' mode='out-in')
                        router-view
                          a-layout-footer
                            cui-footer

</template>

<script>
  import Sidebar from './components/Sidebar'
  import Topbar from './components/Topbar'

  export default {
    // name: 'MainLayout',
    components: { Sidebar, Topbar },
  }
</script>

<style lang="scss" module>

</style>

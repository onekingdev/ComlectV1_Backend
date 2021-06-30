<template lang="pug">
  .container-fluid.p-0
    .d-flex
      Sidebar
      .d-flex.flex-column.flex-grow-1
        Topbar
        main#main-content.flex-grow-1
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
  import Sidebar from '@/common/layout/Sidebar'
  import Topbar from '@/common/layout/Topbar'

  export default {
    name: 'MainLayout',
    components: { Sidebar, Topbar },
    data: function () {
      return {
      }
    },
    mounted() {
    },
    methods: {
    },
  }
</script>

<style lang="scss" module>
  /*@import "./style.module.scss";*/
</style>

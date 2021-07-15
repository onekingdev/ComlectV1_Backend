<template lang="pug">
  .container-fluid.p-0
    Topbar
    .d-flex
      Sidebar
      main.main-content.flex-grow-1
       router-view
</template>

<script>
  import Sidebar from './components/Sidebar'
  import Topbar from './components/Topbar'

  export default {
    components: { Sidebar, Topbar },
  }
</script>

<style lang="scss" module>

</style>

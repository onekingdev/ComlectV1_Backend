<template lang="pug">
  .container-fluid.p-0
    Topbar
    .wrapper
      Sidebar
      main.main-content
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

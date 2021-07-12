<template lang="pug">
  .container-fluid.p-0
    Topbar
    .d-flex.flex-column.flex-grow-1
        main.wrapper#main-content.flex-grow-1
         router-view
</template>

<script>
  import Topbar from '../../layouts/Main/components/Topbar'

  export default {
    name: 'MainLayout',
    components: { Topbar },
  }
</script>

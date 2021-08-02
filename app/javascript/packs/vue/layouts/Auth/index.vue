<template lang="pug">
  .container-fluid
    Topbar
    main#main-content.flex-grow-1
     router-view
</template>

<script>
  import Topbar from '@/auth/components/TopNavbar'

  export default {
    name: 'AuthLayout',
    components: { Topbar },
  }
</script>

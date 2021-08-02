<template lang="pug">
  .container-fluid.px-0
    Topbar
    main#main-content
      router-view
</template>

<script>
  import Topbar from '@/auth/components/TopNavbar'

  export default {
    components: { Topbar },
  }
</script>

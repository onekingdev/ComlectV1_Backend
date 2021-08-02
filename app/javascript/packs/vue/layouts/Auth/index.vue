<template lang="pug">
  .container-fluid.px-0
    Topbar
    main#main-content
      transition(
        type="animation"
        name="ma")
        router-view
</template>

<script>
  import Topbar from '@/auth/components/TopNavbar'

  export default {
    components: { Topbar },
  }
</script>

<style scoped>
  .ma-enter {
    opacity: 0;
  }
  .ma-enter-active {
    /*transition: all 200ms ease-in;*/
    animation: 1s ma-bounce forwards;
    transition-delay: 300ms;
    transition: all 1s ease-in;
  }
  .ma-enter-to {
    opacity: 1;
  }

  .ma-leave {}
  .ma-leave-active {
    animation: 200ms ma-slide forwards;
    transition: all 200ms ease-in;
  }
  .ma-leave-to {
    opacity: 0;
  }

  @keyframes ma-slide {
    from {
      transform:  translateX(0px);
    }
    to {
      transform:  translateX(-1500px);
    }
  }

  @keyframes ma-bounce {
    0%   { transform: scale(1,1)      translateY(0); }
    10%  { transform: scale(1.1,.9)   translateY(0); }
    30%  { transform: scale(.9,1.1)   translateY(-100px); }
    50%  { transform: scale(1.05,.95) translateY(0); }
    57%  { transform: scale(1,1)      translateY(-7px); }
    64%  { transform: scale(1,1)      translateY(0); }
    100% { transform: scale(1,1)      translateY(0); }
  }
</style>

<template lang="pug">
  transition(type="animation"  name="ma")
    .overlay
      .container-fluid
        .row
          .col-xl-3.m-x-auto
            .overlay-block
              h2.overlay-text.m-b-2 {{ overlay.message }}
              //b-icon(v-if="loading" icon="arrow-clockwise" animation="spin" font-scale="7.5")
              .overlay-status(v-if="loading")
                .lds-ring
                  div
                  div
                  div
                  div
              .overlay-status(v-if="!loading && overlay.status === 'success'" )
                .lds-ring.lds-ring-stop
                  div
                  div
                  div
                  div
                ion-icon.overlay-icon(name="checkmark-outline")
                //b-icon(v-if="!loading && status === 'success'" icon="check-circle-fill" variant="success" font-scale="7.5")
              .overlay-status(v-if="!loading && overlay.status === 'error'")
                b-icon(icon="x-circle-fill" variant="danger" font-scale="7.5")
</template>

<script>
  export default {
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      overlay() {
        return this.$store.getters.overlay;
      }
    }
  }
</script>

<style scoped>
  .overlay {
    position: fixed;
    /*display: block; */

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(246,246,248,1);
    z-index: 1060;
    /*cursor: pointer;*/
  }

  .overlay-block {
    display: block;
    position: relative;
    margin: auto;
    width: 100%;
    max-width: 45rem;
    height: 200px;
  }

  .overlay-text {
    margin-bottom: 2.5rem;
    width: 100%;
    text-align: center;
  }

  .overlay-status {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: auto;
    margin-top: 0;
  }

  ion-icon.overlay-icon {
    position: absolute;
    top: 1rem;
    right: 0;
    bottom: 0;
    left: 0;
    margin: auto;
    font-size: 90px;
    --ionicon-stroke-width: 68px;
    /*font-weight: bold;*/
    color: #2E304F;
  }

  .ma-enter {
    opacity: 0;
  }
  .ma-enter-active {
    transition: opacity 1s;
  }
  .ma-enter-to {
    opacity: 1;
  }

  .ma-leave {
    opacity: 1;
  }
  .ma-leave-active {
    animation: 1s ma-slide forwards;
    transition: opacity 3s;
  }
  .ma-leave-to {
    opacity: 0;
  }

  @keyframes ma-slide {
    from {
      transform:  translateX(0px);
    }
    to {
      transform:  translateX(-100vw);
    }
  }
</style>

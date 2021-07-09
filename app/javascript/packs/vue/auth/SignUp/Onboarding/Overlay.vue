<template lang="pug">
  transition(type="animation"  name="ma")
    .overlay(v-if="show")
      .container-fluid
        .row
          .col-xl-3.m-x-auto
            .overlay-text
              h2.m-b-2 {{ statusText }}
              //b-icon(v-if="loading" icon="arrow-clockwise" animation="spin" font-scale="7.5")
              .lds-ring(v-if="loading")
                div
                div
                div
                div
              b-icon(v-if="!loading && status === 'success'" icon="check-circle-fill" variant="success" font-scale="7.5")
              b-icon(v-if="!loading && status === 'error'" icon="x-circle-fill" variant="danger" font-scale="7.5")
</template>

<script>
  export default {
    props: ['status', 'statusText', 'show'],
    data() {
      return {

      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    }
  }
</script>

<style scoped>
  .overlay {
    position: fixed; /* Sit on top of the page content */
    display: block; /* Hidden by default */
    width: 100%; /* Full width (cover the whole page) */
    height: 100%; /* Full height (cover the whole page) */
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(246,246,248,1); /* Black background with opacity */
    z-index: 1060; /* Specify a stack order in case you're using a different order for other elements */
    cursor: pointer; /* Add a pointer on hover */
  }

  .overlay-text {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    width: 100%;
    min-height: 100vh;
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
      transform:  translateX(-1500px);
    }
  }
</style>

<template lang="pug">
  transition(type="animation"  name="ma")
    .overlay(v-if="show")
      .container-fluid
        .row
          .col-xl-3.m-x-auto
            .overlay-text
              h2.m-b-2 {{ statusText }}
              b-icon(v-if="loading" icon="arrow-clockwise" animation="spin" font-scale="7.5")
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
    display: block;
    width: 100%;
    height: 100%;
    background-color: rgba(246,246,248,1);
    cursor: pointer;
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

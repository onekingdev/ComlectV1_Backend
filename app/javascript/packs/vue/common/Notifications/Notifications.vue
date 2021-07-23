<template lang="pug">
  b-alert.notifications(v-if="notify" :show="notify.show" :variant="notify.variant ? notify.variant : 'primary'" :dismissible="notify.dismissible")
    .d-flex.align-items-center
      b-icon.m-r-2.m-l-1(v-if="notifyIcon" :icon="notifyIcon" :animation="notify.animation" :scale="notify.scale" :variant="notify.variant")
      .d-block.mr-auto
        h4(v-if="notify.mainText"): b {{ notify.mainText }}
        p.mb-0(v-if="notify.subText") {{ notify.subText }}
      span(@click="$emit('click')")
        slot
</template>

<script>
  export default {
    props: {
      notify: {
        type: Object,
        required: true,
      }
    },
    components: {

    },
    data() {
      return {
        // EXAMPLE OF OUTSIDE DATA BINDING
        // notify: {
        //   show: 'show',
        //   mainText: 'The project\'s due date tommorow',
        //   subText: 'Do you want to extend the dataline?',
        //   variant: 'success', // OR 'primary', 'success', 'warning', 'danger',
        //   dismissible: false, // OR true
        //   icon: null, // OR 'x-circle-fill' - icon from bootstrap
        //   scale: 2 // size
        //   animation: 'throb' // animations from bootstrap icons
        // }
      }
    },
    computed: {
      notifyIcon() {
        if (this.notify.icon) return this.notify.icon
        const currentVariant = this.notify.variant
        if (currentVariant === 'primary' || currentVariant === 'info') this.notify.icon = ''
        if (currentVariant === 'success') this.notify.icon = 'check-circle-fill'
        if (currentVariant === 'warning') this.notify.icon = 'exclamation-triangle-fill'
        if (currentVariant === 'danger') this.notify.icon = 'dash-circle-fill'
        return this.notify.icon
      }
    }
  }
</script>

<style scoped>
  /* ALERTS*/
  .notifications.alert {
    color: #303132;
    border-radius: 0;
    border-width: 0;
    border-color: transparent;
  }
  .notifications.alert-info,
  .notifications.alert-primary {
    background-color: #ecf4ff;
    box-shadow: inset 5px 0 0 #0479ff;
  }
  .notifications.alert-success {
    background-color: #d5fbef;
    box-shadow: inset 5px 0 0 #1ab27f;
  }
  .notifications.alert-warning {
    background-color: #fff7e4;
    box-shadow: inset 5px 0 0 #ffc900;
  }
  .notifications.alert-danger {
    background-color: #fddee3;
    box-shadow: inset 5px 0 0 #ce1938;
  }
  .notifications.alert-dismissible .close {
    top: 10px;
    font-size: 1.8rem;
  }
</style>

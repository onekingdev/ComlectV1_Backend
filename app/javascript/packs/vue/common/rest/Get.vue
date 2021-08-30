<template lang="pug">
  div(v-if="everythingLoaded")
    slot(v-bind="slotProps")
</template>

<script>
import Vue from 'vue'

export default {
  props: {
    callback: {
      type: Function,
      default: result => result
    },
    etag: {
      type: Number,
      default: Math.random()
    }
  },
  data() {
    return {
      slotProps: {},
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': localStorage.getItem('app.currentUser.token') ? JSON.parse(localStorage.getItem('app.currentUser.token')) : '',
      }
    }
  },
  methods: {
    patchHeader(addr) {
      if (addr.indexOf("/api/local_projects") != 0) {
        const business_id = window.localStorage["app.business_id"]
        if(business_id && (business_id != "undefined")) this.headers.business_id = JSON.parse(business_id)
      }
    },
    refetch() {
      Object.keys(this.$attrs)
        .filter(prop => !!this.$attrs[prop])
        .map(prop => this.patchHeader(this.$attrs[prop]));

      Object.keys(this.$attrs)
            .filter(prop => !!this.$attrs[prop])
            .map(prop => fetch(this.$attrs[prop], { headers: this.headers })
            .then(response => response.json())
            .then(result => Vue.set(this.slotProps, prop, this.callback(result))))
    }
  },
  computed: {
    everythingLoaded() {
      const totalNonEmptyProps = Object.keys(this.$attrs).filter(prop => !!this.$attrs[prop]).length,
            setProps = Object.keys(this.slotProps).length,
            loadedProps = Object.values(this.slotProps).filter(o => typeof(o) === "object").length
      return totalNonEmptyProps === setProps && setProps === loadedProps
    }
  },
  watch: {
    etag: {
      handler: function() {
        this.refetch()
      },
      immediate: true
    }
  }
}
</script>

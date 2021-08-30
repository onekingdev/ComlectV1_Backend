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
    data() {
      return {
        userType: localStorage.getItem('app.currentUser.userType') ? JSON.parse(localStorage.getItem('app.currentUser.userType')) : ''
      }
    },
    mounted() {
      //@TODO move it to dashboard or better solution
      // fetch('/api/specialist/roles')
      //   .then(response => response.json())
      //   .then(response => {
      //     console.log('response in topbar')
      //     if (response[0]) {
      //       const business_id = response[0].business_id
      //       window.localStorage["app.business_id"] = JSON.parse(business_id)
      //     }
      //   })
      //   .catch(error => console.error(error))

      /**
       * Get current rolas if it exist, it will addted to store and localstorage
       */
      this.$store.dispatch("roles/getRoles")
        // .then(response => console.log('getRoles response', response))
        // .catch(err => console.error(err));

      /**
       * Detect current user type and make GET reqeust, if not exist check URL and GET current account info
       */
      if(!this.userType) this.userType = window.location.pathname.split('/')[1]
      if(this.userType === 'business') this.userType = `${this.userType}es`
      if(this.userType === 'specialist') this.userType = `${this.userType}s`
      localStorage.setItem('app.currentUser.userType', JSON.stringify(this.userType))
      this.$store.dispatch("roles/getCurrentAccount", { userType: this.userType })
    },
  }
</script>

<style lang="scss" module>

</style>

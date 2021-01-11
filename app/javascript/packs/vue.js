import Vue from 'vue/dist/vue.esm.js'
import BusinessDashboardPage from './vue/business/DashboardPage.vue'

Vue.config.productionTip = false

new Vue({
  el: document.getElementById('app'),
  components: {
    BusinessDashboardPage
  }
})

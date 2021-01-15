import Vue from 'vue/dist/vue.esm.js'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import bootstrap from 'bootstrap/dist/js/bootstrap.esm.js'
//import icons from 'ionicons/icons'; // I dunno man

Vue.config.productionTip = false

Vue.config.ignoredElements = ['ion-icon']

new Vue({
  el: document.getElementById('app'),
  components: {
    BusinessDashboardPage
  }
})

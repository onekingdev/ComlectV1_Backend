import Vue from 'vue/dist/vue.esm.js'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'

import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

Vue.config.productionTip = false

Vue.config.ignoredElements = ['ion-icon']

Vue.component('Treeselect', Treeselect)

new Vue({
  el: document.getElementById('app'),
  components: {
    BusinessDashboardPage
  }
})

import Vue from 'vue/dist/vue.esm.js'
import store from '@/store/index'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import DatePicker from '@/common/DatePicker'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

Vue.config.productionTip = false

Vue.config.ignoredElements = ['ion-icon']

Vue.component('Treeselect', Treeselect)
Vue.component('DatePicker', DatePicker)

new Vue({
  el: document.getElementById('app'),
  store,
  data() {
    return {
      isProfileMenuOpen: false
    }
  },
  components: {
    BusinessDashboardPage
  }
})

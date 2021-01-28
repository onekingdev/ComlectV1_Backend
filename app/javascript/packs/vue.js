import Vue from 'vue/dist/vue.esm.js'
import store from '@/store/index'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import RemindersPage from './vue/business/reminders/Page.vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import DatePicker from '@/common/DatePicker'
import ComboBox from '@/common/ComboBox'
import Dropdown from '@/common/Dropdown'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

Vue.config.productionTip = false
Vue.config.ignoredElements = ['ion-icon']

Vue.component('Treeselect', Treeselect)
Vue.component('DatePicker', DatePicker)
Vue.component('ComboBox', ComboBox)
Vue.component('Dropdown', Dropdown)

new Vue({
  el: document.getElementById('app'),
  store,
  data() {
    return {
      isProfileMenuOpen: false
    }
  },
  components: {
    BusinessDashboardPage,
    RemindersPage
  }
})

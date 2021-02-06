import Vue from 'vue/dist/vue.esm.js'
import store from '@/store/index'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import BusinessRemindersPage from './vue/business/reminders/Page.vue'
import BusinessPostProjectPage from './vue/business/projects/PostProjectPage.vue'
import BusinessProjectsPage from './vue/business/projects/Page.vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import DatePicker from '@/common/DatePicker'
import Breadcrumbs from '@/common/Breadcrumbs'
import ComboBox from '@/common/ComboBox'
import Dropdown from '@/common/Dropdown'
import Errors from '@/common/Errors'
import filters from './vue/filters'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

Vue.config.productionTip = false
Vue.config.ignoredElements = ['ion-icon']

Object.keys(filters).map(filter => Vue.filter(filter, filters[filter]))

Vue.component('Treeselect', Treeselect)
Vue.component('DatePicker', DatePicker)
Vue.component('Breadcrumbs', Breadcrumbs)
Vue.component('ComboBox', ComboBox)
Vue.component('Dropdown', Dropdown)
Vue.component('Errors', Errors)

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
    BusinessRemindersPage,
    BusinessProjectsPage,
    BusinessPostProjectPage
  }
})

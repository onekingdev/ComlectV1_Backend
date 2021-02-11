import Vue from 'vue/dist/vue.esm.js'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import DatePicker from '@/common/DatePicker'
import Breadcrumbs from '@/common/Breadcrumbs'
import ComboBox from '@/common/ComboBox'
import Dropdown from '@/common/Dropdown'
import Errors from '@/common/Errors'
import InputText from '@/common/InputText'
import InputTextarea from '@/common/InputTextarea'
import filters from '@/filters'
import { extractToastMessage } from '@/common/Toast'

const data = () => ({
  isProfileMenuOpen: false
})

const init = configuration => {
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
  Vue.component('InputText', InputText)
  Vue.component('InputTextarea', InputTextarea)

  return new Vue({
    el: document.getElementById('app'),
    ...(configuration || {}),
    data,
    created() {
      const toast = extractToastMessage()
      if (toast) {
        this.$bvToast.toast(toast, { autoHideDelay: 5000 })
      }
    }
  })
}

export default init
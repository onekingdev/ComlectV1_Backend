import Vue from 'vue/dist/vue.esm.js'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import DatePicker from '@/common/DatePicker'
import Breadcrumbs from '@/common/Breadcrumbs'
import ComboBox from '@/common/ComboBox'
import Dropdown from '@/common/Dropdown'
import Errors from '@/common/Errors'
import InputDate from '@/common/InputDate'
import InputText from '@/common/InputText'
import InputTextarea from '@/common/InputTextarea'
import InputNumber from '@/common/InputNumber'
import InputSelect from '@/common/InputSelect'
import InputRating from '@/common/InputRating'
import StarRating from '@/common/StarRating'
import UserAvatar from '@/common/UserAvatar'
import PropertiesTable from '@/common/PropertiesTable'
import CommonHeader from '@/common/CommonHeader'
import Get from '@/common/rest/Get'
import Post from '@/common/rest/Post'
import Put from '@/common/rest/Put'
import Delete from '@/common/rest/Delete'
import ModelLoader from '@/common/rest/ModelLoader'
import filters from '@/filters'
import { extractToastMessage } from '@/common/Toast'
import ToasterMixin from '@/mixins/ToasterMixin'
import RedirectMixin from '@/mixins/RedirectMixin'
import HistoryMixin from '@/mixins/HistoryMixin'
import vueDebounce from 'vue-debounce'

const data = () => ({
  isProfileMenuOpen: false
})

const init = configuration => {
  Vue.use(BootstrapVue)
  Vue.use(IconsPlugin)
  Vue.use(vueDebounce)

  Vue.mixin(ToasterMixin)
  Vue.mixin(RedirectMixin)
  Vue.mixin(HistoryMixin)

  Vue.config.productionTip = false
  Vue.config.ignoredElements = ['ion-icon']

  Object.keys(filters).map(filter => Vue.filter(filter, filters[filter]))

  Vue.component('Treeselect', Treeselect)
  Vue.component('DatePicker', DatePicker)
  Vue.component('Breadcrumbs', Breadcrumbs)
  Vue.component('ComboBox', ComboBox)
  Vue.component('Dropdown', Dropdown)
  Vue.component('Errors', Errors)
  Vue.component('InputDate', InputDate)
  Vue.component('InputText', InputText)
  Vue.component('InputTextarea', InputTextarea)
  Vue.component('InputNumber', InputNumber)
  Vue.component('InputSelect', InputSelect)
  Vue.component('InputRating', InputRating)
  Vue.component('StarRating', StarRating)
  Vue.component('UserAvatar', UserAvatar)
  Vue.component('PropertiesTable', PropertiesTable)
  Vue.component('CommonHeader', CommonHeader)
  Vue.component('Get', Get)
  Vue.component('Post', Post)
  Vue.component('Put', Put)
  Vue.component('Delete', Delete)
  Vue.component('ModelLoader', ModelLoader)

  Vue.directive('google-maps-autocomplete', {
    inserted(el) {
      new google.maps.places.Autocomplete(el)
    }
  })

  return new Vue({
    el: document.getElementById('app'),
    mixins: [ToasterMixin, RedirectMixin, HistoryMixin],
    ...(configuration || {}),
    data,
    created() {
      const toast = extractToastMessage()
      toast && this.toast('', toast)
    }
  })
}

export default init

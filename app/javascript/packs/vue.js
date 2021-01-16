import Vue from 'vue/dist/vue.esm.js'
import {$,jQuery} from 'jquery';
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import bootstrap from 'bootstrap/dist/js/bootstrap.min.js'
//import '~bootstrap-vue';

//import icons from 'ionicons/icons'; // I dunno man

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

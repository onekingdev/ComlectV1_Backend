import Vue from 'vue'
import Router from 'vue-router'
// import AuthGuard from './auth-guard'
import Dashboard from '@/business/dashboard/Page'
import Policies from '@/business/policies/Page'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '',
      name: 'policies',
      component: Policies
    },
  ],
  mode: 'history'
})

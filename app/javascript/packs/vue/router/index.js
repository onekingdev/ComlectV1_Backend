import Vue from 'vue'
import Router from 'vue-router'
// import AuthGuard from './auth-guard'
import Dashboard from '@/business/dashboard/Page'
import Policies from '@/business/policies/Page'
import AnnualReviews from '@/business/annual/Page'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/business',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '/business/compliance_policies',
      name: 'policies',
      component: Policies
    },
    {
      path: '/business/annual_reviews',
      name: 'annual-reviews',
      component: AnnualReviews
    },
  ],
  mode: 'history'
})

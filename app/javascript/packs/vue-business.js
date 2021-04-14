import init from './vue/init'
import store from '@/store/business'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import BusinessRemindersPage from './vue/business/reminders/Page.vue'
import BusinessPostProjectPage from './vue/business/projects/PostProjectPage.vue'
import BusinessProjectsPage from './vue/business/projects/Page.vue'
import ProjectShowPage from '@/business/projects/ShowPage'
import ProjectShowPostPage from '@/business/projects/ShowPostPage'
import RemindersPage from '@/business/reminders/Page'
import TimesheetsShowPage from '@/business/projects/TimesheetsShowPage'

import BusinessPoliciesPage from './vue/business/policies/Page.vue'
import BusinessPoliciesCreatePage from './vue/business/policies/Details/PolicyCreate.vue'

const businesPolicies = {
  BusinessPoliciesPage,
  BusinessPoliciesCreatePage,
}

import BusinessReportsRisksPage from './vue/business/reportsrisks/Page.vue'

const BusinessReportsRisks = {
  BusinessReportsRisksPage,
}

init({
  store,
  components: {
    BusinessDashboardPage,
    BusinessRemindersPage,
    BusinessProjectsPage,
    BusinessPostProjectPage,
    ProjectShowPage,
    ProjectShowPostPage,
    RemindersPage,
    TimesheetsShowPage,

    ...businesPolicies,
    ...BusinessReportsRisks
  }
})

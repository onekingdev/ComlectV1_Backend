import init from './vue/init'
import store from '@/store/index'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import BusinessRemindersPage from './vue/business/reminders/Page.vue'
import BusinessPostProjectPage from './vue/business/projects/PostProjectPage.vue'
import BusinessProjectsPage from './vue/business/projects/Page.vue'
import ProjectShowPage from '@/business/projects/ShowPage'
import ApplicationsIndexPage from '@/business/applications/IndexPage'
import RemindersPage from '@/business/reminders/Page'

init({
  store,
  components: {
    BusinessDashboardPage,
    BusinessRemindersPage,
    BusinessProjectsPage,
    BusinessPostProjectPage,
    ProjectShowPage,
    ApplicationsIndexPage,
    RemindersPage
  }
})

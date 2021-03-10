import init from './vue/init'
import store from '@/store/business'
import BusinessDashboardPage from './vue/business/dashboard/Page.vue'
import BusinessRemindersPage from './vue/business/reminders/Page.vue'
import BusinessPostProjectPage from './vue/business/projects/PostProjectPage.vue'
import BusinessProjectsPage from './vue/business/projects/Page.vue'
import ProjectShowPage from '@/business/projects/ShowPage'
import ProjectShowPostPage from '@/business/projects/ShowPostPage'
import ApplicationsIndexPage from '@/business/applications/IndexPage'
import RemindersPage from '@/business/reminders/Page'
import TimesheetsShowPage from '@/business/projects/TimesheetsShowPage'

init({
  store,
  components: {
    BusinessDashboardPage,
    BusinessRemindersPage,
    BusinessProjectsPage,
    BusinessPostProjectPage,
    ProjectShowPage,
    ProjectShowPostPage,
    ApplicationsIndexPage,
    RemindersPage,
    TimesheetsShowPage,
  }
})

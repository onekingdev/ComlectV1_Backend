import init from '@/init'
import store from '@/store/specialist'
import router from '@/router'
import MainLayoyt from './vue/layouts/Main'
import SpecialistDashboardPage from './vue/business/dashboard/Page.vue'
import ProjectIndexPage from '@/specialist/projects/IndexPage'
import CreateProposalPage from '@/specialist/projects/CreateProposalPage'
import MyProjectsPage from '@/specialist/projects/MyProjectsPage'
import MyProjectShowPage from '@/specialist/projects/MyProjectShowPage'
import ProjectTimesheetsPage from '@/specialist/projects/ProjectTimesheetsPage'

import SpecialistSettingsPage from './vue/specialist/settings/Page.vue'
import SpecialistProfilePage from './vue/specialist/profile/Page.vue'
const SpecialistSettings = {
  SpecialistSettingsPage,
  SpecialistProfilePage,
}

init({
  store,
  router,
  components: {
    MainLayoyt,
    SpecialistDashboardPage,
    ProjectIndexPage,
    CreateProposalPage,
    MyProjectsPage,
    MyProjectShowPage,
    ProjectTimesheetsPage,
    ...SpecialistSettings,
  }
})

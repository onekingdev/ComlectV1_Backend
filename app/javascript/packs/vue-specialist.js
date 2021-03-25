import init from '@/init'
import store from '@/store/specialist'
import ProjectIndexPage from '@/specialist/projects/IndexPage'
import CreateProposalPage from '@/specialist/projects/CreateProposalPage'
import MyProjectsPage from '@/specialist/projects/MyProjectsPage'
import MyProjectShowPage from '@/specialist/projects/MyProjectShowPage'
import ProjectTimesheetsPage from '@/specialist/projects/ProjectTimesheetsPage'

init({
  store,
  components: {
    ProjectIndexPage,
    CreateProposalPage,
    MyProjectsPage,
    MyProjectShowPage,
    ProjectTimesheetsPage,
  }
})
import Vue from 'vue'
import Router from 'vue-router'
// import AuthGuard from './auth-guard'
import Dashboard from '@/business/dashboard/Page'
import Projects from '@/business/projects/Page'
import ProjectReview from '@/business/projects/ShowPage'
import Tasks from '@/business/tasks/Page'
import Policies from '@/business/policies/Page'
import PolicyCurrent from '@/business/policies/Details/PolicyCreate'
import PolicyCurrentNoSections from '@/business/policies/Details/PolicyDetailsWithoutSections'
import AnnualReviews from '@/business/annual/Page'
import AnnualReviewsCurrentGeneral from '@/business/annual/PageCurrentGeneral'
import AnnualReviewsCurrentReviewCategory from '@/business/annual/PageCurrentReviewCategory'
import Risks from '@/business/riskregister/Page'
import RiskDetail from '@/business/riskregister/RiskDetail'
import ReportsRisks from '@/business/reportsrisks/Page'
import FileFolders from '@/business/filefolders/Page'
import Exams from '@/business/exammanagement/Page'
import Settings from '@/business/settings/Page'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/business',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '/business/projects',
      name: 'projects',
      component: Projects
    },
    {
      path: '/business/projects/:projectId',
      name: 'project-review',
      props: true,
      component: ProjectReview
    },
    {
      path: '/business/reminders',
      name: 'tasks',
      component: Tasks
    },
    {
      path: '/business/compliance_policies',
      name: 'policies',
      component: Policies
    },
    {
      path: '/business/compliance_policies/:policyId',
      name: 'policy-current',
      props: true,
      component: PolicyCurrentNoSections
    },
    {
      path: '/business/annual_reviews',
      name: 'annual-reviews',
      component: AnnualReviews
    },
    {
      path: '/business/annual_reviews/:annualId',
      name: 'annual-reviews-general',
      props: true,
      component: AnnualReviewsCurrentGeneral,
    },
    {
      path: '/business/annual_reviews/:annualId/:revcatId',
      name: 'annual-reviews-review-category',
      props: true,
      component: AnnualReviewsCurrentReviewCategory
    },

    {
      path: '/business/risks',
      name: 'risks',
      component: Risks
    },
    {
      path: '/business/risks/:riskId',
      name: 'risk-review',
      props: true,
      component: RiskDetail
    },
    {
      path: '/business/file_folders',
      name: 'file-folders',
      component: FileFolders
    },
    {
      path: '/business/exam_management',
      name: 'exam-management',
      component: Exams
    },
    {
      path: '/business/reports/risks',
      name: 'reports-risks',
      component: ReportsRisks
    },
    {
      path: '/business/settings',
      name: 'settings',
      component: Settings
    },
  ],
  mode: 'history'
})

import Vue from 'vue'
import Router from 'vue-router'
import AuthGuard from './auth-guard'

// BUSINESS
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
import ExamCurrentReview from '@/business/exammanagement/PageCurrentReviewExam'
import Settings from '@/business/settings/Page'
import SettingsNotifications from '@/business/notifications/Page'
import SpecialistsMarketplace from '@/business/marketplace/Page'

// SPECIALISTS
import DashboardS from '@/specialist/dashboard/Page'
import SettingsS from '@/specialist/settings/Page'

Vue.use(Router)

export default new Router({
  routes: [
    // BUSINESS
    { path: '/business', name: 'dashboard', component: Dashboard },
    { path: '/business/projects', name: 'projects', component: Projects },
    { path: '/business/projects/:projectId', name: 'project-review', props: true, component: ProjectReview },
    { path: '/business/reminders', name: 'tasks', component: Tasks },
    { path: '/business/compliance_policies', name: 'policies', component: Policies, beforeEnter: AuthGuard },
    { path: '/business/compliance_policies/:policyId', name: 'policy-current', props: true, component: PolicyCurrentNoSections, beforeEnter: AuthGuard },
    { path: '/business/annual_reviews', name: 'annual-reviews', component: AnnualReviews },
    { path: '/business/annual_reviews/:annualId', name: 'annual-reviews-general', props: true, component: AnnualReviewsCurrentGeneral, },
    { path: '/business/annual_reviews/:annualId/:revcatId', name: 'annual-reviews-review-category', props: true, component: AnnualReviewsCurrentReviewCategory },
    { path: '/business/risks', name: 'risks', component: Risks },
    { path: '/business/risks/:riskId', name: 'risk-review', props: true, component: RiskDetail },
    { path: '/business/file_folders', name: 'file-folders', component: FileFolders },
    { path: '/business/exam_management', name: 'exam-management', component: Exams },
    { path: '/business/exam_management/:examId', name: 'exam-management-current-review', props: true, component: ExamCurrentReview },
    { path: '/business/reports/risks', name: 'reports-risks', component: ReportsRisks },
    { path: '/business/settings', name: 'settings', component: Settings,
      children:  [
        { path: '/business/settings/general', name: 'settings-general', component: Settings, },
        { path: '/business/settings/users', name: 'settings-users', component: Settings, },
        { path: '/business/settings/roles', name: 'settings-roles', component: Settings, },
        { path: '/business/settings/security', name: 'settings-security', component: Settings, },
        { path: '/business/settings/subscriptions', name: 'settings-subscriptions', component: Settings, },
        { path: '/business/settings/billings', name: 'settings-billings', component: Settings, },
        { path: '/business/settings/notifications', name: 'settings-notifications', component: Settings, }
      ],
    },
    { path: '/business/settings/notification-center', name: 'settings-notification-center', component: SettingsNotifications },
    { path: '/business/specialists', name: 'specialists-marketplace', component: SpecialistsMarketplace },

    // SPECIALISTS
    { path: '/specialist', name: 'dashboard-specialist', component: DashboardS },
    { path: '/specialist/settings', name: 'settings', component: SettingsS,
      children:  [
        { path: '/specialist/settings/general', name: 'settings-general', component: SettingsS, },
        { path: '/specialist/settings/users', name: 'settings-users', component: SettingsS, },
        { path: '/specialist/settings/roles', name: 'settings-roles', component: SettingsS, },
        { path: '/specialist/settings/security', name: 'settings-security', component: SettingsS, },
        { path: '/specialist/settings/subscriptions', name: 'settings-subscriptions', component: SettingsS, },
        { path: '/specialist/settings/billings', name: 'settings-billings', component: SettingsS, },
        { path: '/specialist/settings/notifications', name: 'settings-notifications', component: SettingsS, }
      ],
    },
  ],
  mode: 'history'
})

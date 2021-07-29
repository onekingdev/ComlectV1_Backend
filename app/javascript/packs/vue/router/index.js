import Vue from 'vue'
import Router from 'vue-router'
// import AuthGuard from './auth-guard'

// AUTH
// import signIn from '@/auth/SingIn/Page'
// import signUp from '@/auth/SignUp/Page'
// import ResetPassword from '@/auth/ResetPassword/Page'
// import ChangePassword from '@/auth/ChangePassword/Page'

// BUSINESS
import Dashboard from '@/business/dashboard/Page'
import Projects from '@/business/projects/Page'
import ProjectReview from '@/business/projects/ShowPage'
import PostProjectPage from '@/business/projects/PostProjectPage'
import ShowPostPage from '@/business/projects/ShowPostPage'
import ProjectTimesheetsShowPage from '@/business/projects/TimesheetsShowPage'
import Tasks from '@/business/tasks/Page'
import Policies from '@/business/policies/Page'
import PoliciesEntire from '@/business/policies/PoliciesEntire'
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
import Profile from '@/business/profile/Page'
import Settings from '@/business/settings/Page'
import SettingsNotifications from '@/business/notifications/Page'
import SpecialistsMarketplace from '@/business/marketplace/Page'

// SPECIALISTS
import DashboardS from '@/specialist/dashboard/Page'
import ProjectsS from '@/specialist/projects/MyProjectsPage'
import ProjectReviewS from '@/specialist/projects/MyProjectShowPage'
import SettingsS from '@/specialist/settings/Page'
import SettingsNotificationsS from '@/specialist/notifications/Page'
import ProjectsMarketplaceS from '@/specialist/projects/IndexPage'

Vue.use(Router)

export default new Router({
  routes: [
    // REDIRECTS
    // { path: '/business', redirect: '/business/dashboard' },
    // { path: '/business/dashboard', redirect: '/business/dashboard' },
    // { path: '/specialist', redirect: '/specialist/dashboard' },
    // { path: '/specialist/dashboard', redirect: '/specialist/dashboard' },

    // AUTH
    // { path: '/users/sign_in', name: 'sign-in', component: signIn },
    // { path: '/users/sign_up', name: 'sign-up', component: signUp },
    // { path: '/users/password/new', name: 'password-new', component: ResetPassword },
    // { path: '/users/password/change', name: 'password-change', component: ChangePassword },

    // BUSINESS
    { path: '/business', name: 'dashboard', component: Dashboard },
    { path: '/business/projects', name: 'projects', component: Projects },
    { path: '/business/projects/:id(\\d+)', name: 'project-review', props: route => ({ projectId: +route.params.id }), component: ProjectReview },
    { path: '/business/projects/:id(\\d+)/timesheets', name: 'project-timesheets', props: route => ({ projectId: +route.params.id }), component: ProjectTimesheetsShowPage },
    { path: '/business/projects/new', name: 'project-post', component: PostProjectPage },
    { path: '/business/projects/new/:id(\\d+)', name: 'project-post-from-local', props: route => ({ localProjectId: +route.params.id }), component: PostProjectPage },
    { path: '/business/project_posts/:id(\\d+)', name: 'project-post-view', props: route => ({ projectId: +route.params.id }), component: ShowPostPage },
    { path: '/business/project_posts/:id(\\d+)/edit', name: 'project-post-edit', props: route => ({ projectId: +route.params.id }), component: PostProjectPage },
    { path: '/business/reminders', name: 'tasks', component: Tasks },
    // { path: '/business/compliance_policies', name: 'policies', component: Policies, beforeEnter: AuthGuard },
    { path: '/business/compliance_policies', name: 'policies', component: Policies, },
    { path: '/business/compliance_policies/entire', name: 'policies-entire', props: true, component: PoliciesEntire },
    { path: '/business/compliance_policies/:policyId(\\d+)', name: 'policy-current', props: true, component: PolicyCurrentNoSections },
    { path: '/business/annual_reviews', name: 'annual-reviews', component: AnnualReviews },
    { path: '/business/annual_reviews/:annualId', name: 'annual-reviews-general', props: true, component: AnnualReviewsCurrentGeneral, },
    { path: '/business/annual_reviews/:annualId/:revcatId', name: 'annual-reviews-review-category', props: true, component: AnnualReviewsCurrentReviewCategory },
    { path: '/business/risks', name: 'risks', component: Risks },
    { path: '/business/risks/:riskId', name: 'risk-review', props: true, component: RiskDetail },
    { path: '/business/file_folders', name: 'file-folders', component: FileFolders },
    { path: '/business/exam_management', name: 'exam-management', component: Exams },
    { path: '/business/exam_management/:examId', name: 'exam-management-current-review', props: true, component: ExamCurrentReview },
    { path: '/business/reports/risks', name: 'reports-risks', component: ReportsRisks },
    { path: '/business/profile', name: 'profile', component: Profile},
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
    { path: '/specialist/projects', name: 'projects-specialist', component: ProjectsS },
    { path: '/specialist/projects/:projectId', name: 'project-review-specialist', props: true, component: ProjectReviewS },
    { path: '/specialist/settings', name: 'settings-specialist', component: SettingsS,
      children:  [
        { path: '/specialist/settings/general', name: 'settings-general-specialist', component: SettingsS, },
        { path: '/specialist/settings/users', name: 'settings-users-specialist', component: SettingsS, },
        { path: '/specialist/settings/roles', name: 'settings-roles-specialist', component: SettingsS, },
        { path: '/specialist/settings/security', name: 'settings-security-specialist', component: SettingsS, },
        { path: '/specialist/settings/subscriptions', name: 'settings-subscriptions-specialist', component: SettingsS, },
        { path: '/specialist/settings/billings', name: 'settings-billings-specialist', component: SettingsS, },
        { path: '/specialist/settings/notifications', name: 'settings-notifications-specialist', component: SettingsS, }
      ],
    },
    { path: '/specialist/settings/notification-center', name: 'settings-notification-center-specialist', component: SettingsNotificationsS },
    { path: '/specialist/projects-marketpalce', name: 'projects-marketpalce-specialist', component: ProjectsMarketplaceS },
  ],
  mode: 'history'
})

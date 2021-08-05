import init from './vue/init'
import store from '@/store/common'
import router from '@/router'

import AuthLayoyt from './vue/layouts/Auth'

// import SignupPage from './vue/auth/SignUp/Page.vue'
// import SigninPage from './vue/auth/SingIn/Page.vue'
// import ResetPasswordPage from './vue/auth/ResetPassword/Page.vue'
// import ChangePasswordPage from './vue/auth/ChangePassword/Page.vue'
// import SpecialistOnboardingPage from './vue/auth/SignUp/Onboarding/Specialist/SpecialistPage.vue'
// import BusinessOnboardingPage from './vue/auth/SignUp/Onboarding/Business/BusinessPage.vue'
import BusinessExamManagementAuditorPortalShowPage from './vue/business/exammanagement/PageAuditorPortalInternalAccess.vue'
import ExamManagementAuditorPortal from './vue/business/exammanagement/PageAuditorPortalExternalAccess.vue'

init({
  store,
  router,
  components: {
    AuthLayoyt,
    // SignupPage,
    // SigninPage,
    // ResetPasswordPage,
    // ChangePasswordPage,
    // SpecialistOnboardingPage,
    // BusinessOnboardingPage,
    BusinessExamManagementAuditorPortalShowPage,
    ExamManagementAuditorPortal
  }
})

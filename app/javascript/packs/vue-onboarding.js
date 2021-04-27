import init from './vue/init'
import store from '@/store/common'
import BusinessSignupPage from './vue/auth/SignUp/Page.vue'
import BusinessSigninPage from './vue/auth/SingIn/Page.vue'
import SpecialistOnboardingPage from './vue/auth/SignUp/Onboarding/Specialist/SpecialistPage.vue'
import BusinessOnboardingPage from './vue/auth/SignUp/Onboarding/Business/BusinessPage.vue'

init({
  store,
  components: {
    BusinessSignupPage,
    BusinessSigninPage,
    SpecialistOnboardingPage,
    BusinessOnboardingPage
  }
})

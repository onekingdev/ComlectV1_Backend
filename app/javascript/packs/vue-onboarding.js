import init from './vue/init'
import store from '@/store/business'
import BusinessSignupPage from './vue/auth/SignUp/Page.vue'
import SpecialistOnboardingPage from './vue/auth/SignUp/Onboarding/Specialist/SpecialistPage.vue'
import BusinessOnboardingPage from './vue/auth/SignUp/Onboarding/Business/BusinessPage.vue'

init({
  store,
  components: {
    BusinessSignupPage,
    SpecialistOnboardingPage,
    BusinessOnboardingPage
  }
})

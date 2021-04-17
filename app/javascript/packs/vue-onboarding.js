import init from './vue/init'
import BusinessSignupPage from './vue/auth/SignUp/Business/Page.vue'
import SpecialistOnboardingPage from './vue/onboarding/SpecialistPage.vue'
import BusinessOnboardingPage from './vue/onboarding/BusinessPage.vue'

init({
  components: {
    BusinessSignupPage,
    SpecialistOnboardingPage,
    BusinessOnboardingPage
  }
})

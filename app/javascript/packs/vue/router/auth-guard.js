// import store from '@/store/commonModules/shared'
import store from '@/store/business'

const plans = ['free', 'business', 'team']
const roles = ['basic', 'trusted', 'admin']

export default function (to, from, next) {
  if (store.getters['roles/currentPlan'] === 'free') {
    next(`/access-denied`)
  } else {
    next()
  }
  // if (store.getters['roles/currentRole'] === 'basic') {
  //   next(`/access-denied`)
  // } else {
  //   next()
  // }
  // if (store.getters.userType === 'business' || store.getters.userType === 'specialist') {
  //   next()
  // } else {
  //   next(`/users/sign_up`)
  // }
}

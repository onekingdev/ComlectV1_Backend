import store from '@/store/commonModules/shared'

export default function (to, from, next) {
  if (store.getters.userType === 'business' || store.getters.userType === 'specialist') {
    // next()
  } else {
    // next(`/users/sign_up`)
  }
}

import store from '@/store/common'

export default function (to, from, next) {
  if (store.getters.userType === 'business') {
    next()
  } else {
    next(`${store.getters.userType}/dashboard`)
  }
}

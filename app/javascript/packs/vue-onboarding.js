import init from './vue/init'
import store from '@/store/common'
import router from '@/router'
import AuthLayout from './vue/layouts/Auth'

init({
  store,
  router,
  components: {
    AuthLayout,
  }
})

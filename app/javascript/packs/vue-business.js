import init from './vue/init'
import store from '@/store/business'
import router from '@/router'
import MainLayout from './vue/layouts/Main'

init({
  store,
  router,
  components: {
    MainLayout,
  }
})

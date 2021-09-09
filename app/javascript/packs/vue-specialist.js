import init from '@/init'
import store from '@/store/specialist'
import router from '@/router'
import MainLayout from './vue/layouts/Main'

init({
  store,
  router,
  components: {
    MainLayout,
  }
})

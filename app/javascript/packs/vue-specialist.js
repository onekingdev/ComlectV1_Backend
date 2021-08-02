import init from '@/init'
import store from '@/store/specialist'
import router from '@/router'
import MainLayoyt from './vue/layouts/Main'

init({
  store,
  router,
  components: {
    MainLayoyt,
  }
})

import instance from 'axios'
import store  from '../../store/business'
// import { createToast } from "../../mixins/ToasterMixin";

const axios = instance.create({
  baseURL: '/api',
  timeout: 1000,
  headers: {'Accept': 'application/json'}
})

axios.interceptors.request.use((request) => {
  // const accessToken = store.get('accessToken')
  const accessToken = store.getters['accessToken']
  if (accessToken) {
      request.headers.Authorization = `${accessToken}`
      // request.headers.AccessToken = accessToken
  }

  const jwtToken = window.localStorage.getItem('app.currentUser.token')
  if (jwtToken) {
      request.headers['Authorization'] = `${JSON.parse(jwtToken)}`
      // request.headers['X-Auth-Token'] = jwtToken
  }

  return request
})

axios.interceptors.response.use(undefined, (error) => {
  // Errors handling
  const { response } = error
  const { data } = response
  if (data) {
    console.log('data interceprots', data)
    // createToast.toast('Error', data, true)
  }
  throw data
})

export default axios

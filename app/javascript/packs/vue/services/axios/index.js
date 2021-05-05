// import axios from '@/axios'
import store from '../../store/business'

const axios = axios.create({
  baseURL: '/api',
  timeout: 1000,
  headers: {'Accept': 'application/json'}
})

axios.interceptors.request.use((request) => {
  const accessToken = store.get('accessToken')
  if (accessToken) {
      request.headers.Authorization = `Bearer ${accessToken}`
      request.headers.AccessToken = accessToken
  }

  const jwtToken = window.localStorage.getItem('app.currentUser')
  if (jwtToken) {
      request.headers['X-Auth-Token'] = jwtToken
  }
  return request
})

axios.interceptors.response.use(undefined, (error) => {
  // Errors handling
  const { response } = error
  const { data } = response
  if (data) {
    console.log(data)
  }
})

export default axios

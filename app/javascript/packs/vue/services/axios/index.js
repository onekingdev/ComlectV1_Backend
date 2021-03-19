// import axios from 'axios'
import store from 'store'
import { notification } from 'ant-design-vue'

const apiClient = axios.create({
    baseURL: '/api/business/',
    timeout: 1000,
    headers: {'Accept': 'application/json'}
})

apiClient.interceptors.request.use((request) => {
    const accessToken = store.get('accessToken')
    if (accessToken) {
        request.headers.Authorization = `Bearer ${accessToken}`
        request.headers.AccessToken = accessToken
    }

    // const jwtToken = window.localStorage.getItem('app.currentUser')
    // if (jwtToken) {
    //     request.headers['X-Auth-Token'] = jwtToken
    // }
    return request
})

apiClient.interceptors.response.use(undefined, (error) => {
    // Errors handling
    const { response } = error
    const { data } = response
    if (data) {
        console.log(data)
    }
})

export default apiClient

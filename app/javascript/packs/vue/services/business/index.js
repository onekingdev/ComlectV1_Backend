import axios from '@/services/axios'
import store from 'store'

export async function createPolicy(email, password, name) {
  return axios
    .post('/api/business/compliance_policies/create', {
      email,
      password,
      name,
    })
    .then(response => {
      if (response) {
        const { accessToken } = response.data
        if (accessToken) {
          store.set('accessToken', accessToken)
        }
        return response.data
      }
      return false
    })
    .catch(err => console.log(err))
}

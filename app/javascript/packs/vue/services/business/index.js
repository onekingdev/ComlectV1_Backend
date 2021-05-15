import axios from '../../services/axios'
import store from '../../store/business'

export async function createPolicy(newPolicy) {
  return axios
    .post('/business/compliance_policies', {
      compliance_policy: {
        name: newPolicy.name,
      }
    })
    .then(response => {
      if (response) {
        console.log('response', response)
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

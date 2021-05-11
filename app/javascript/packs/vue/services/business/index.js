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

export async function updatePolicySetup(payload) {
   const config = {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  };
  return await axios.patch(`/business/compliance_policy_configuration`, payload, config)
    .then(response => {
      if (response) {
        console.log('response', response)
        return response.data
      }
      return false
    })
    .catch(err => console.log(err))
}

import axios from '../../services/axios'
import store from '../../store/business'

const END_POINT = '/specialist/projects/my'

export async function getProjects() {
  return axios
    .get(`${END_POINT}`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}


export async function createProject(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

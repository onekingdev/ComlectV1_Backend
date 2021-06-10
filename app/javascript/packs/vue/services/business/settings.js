import axios from '../../services/axios'

const END_POINT = '/business/settings'

export async function getSettings() {
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

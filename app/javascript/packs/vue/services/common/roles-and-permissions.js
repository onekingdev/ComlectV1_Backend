import axios from '../axios'

const END_POINT = '/specialist'

export async function getRoles() {
  return axios
    .get(`${END_POINT}/roles`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}

export async function getCurrentAccount(payload) {
  return axios
    .get(`/${payload.userType}/current`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}

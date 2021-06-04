import axios from '../../services/axios'
import store from '../../store/business'

const END_POINT = '/business/specialists'

export async function getSpecialists() {
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

export async function createSpecialists(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updateSpecialists(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function deleteSpecialists(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function getSpecialistsById(payload) {
  return await axios.get(`${END_POINT}/${payload}`)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}



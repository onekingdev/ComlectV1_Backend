import axios from '../axios'

const END_POINT = '/settings'

export async function getGeneralSettings() {
  return axios
    .get(`${END_POINT}/general`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}

export async function updateGeneralSettings(payload) {
  return await axios.patch(`${END_POINT}/general`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updatePasswordSettings(payload) {
  return await axios.patch(`${END_POINT}/password`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function getNotificationsSettings() {
  return axios
    .get(`${END_POINT}/notifications`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}

export async function updateNotificationsSettings(payload) {
  return await axios.patch(`${END_POINT}/notifications`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

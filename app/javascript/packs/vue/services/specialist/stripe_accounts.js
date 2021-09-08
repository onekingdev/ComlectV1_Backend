import axios from "../../services/axios"

const END_POINT = "/specialist/billings";

export async function getStripeAccount() {
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

export async function createStripeAccount(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updateStripeAccount(payload) {
  return await axios.put(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

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

export async function updateSubscribe(payload) {
  axios.defaults.timeout = 10000;
  const { userType, paymentSourceId, planName } = { ...payload }
  const endPoint = userType === 'business' ? 'business' : 'specialist'
  return await axios.post(`/${endPoint}/upgrade/subscribe`, { plan: planName }, { params: {
      payment_source_id: paymentSourceId
    }})
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updateSeatsSubscribe(payload) {
  axios.defaults.timeout = 10000;
  const { userType, stripeToken } = { ...payload }
  const endPoint = userType === 'business' ? 'business/payment_settings' : 'specialist/payment_settings/create_card'
  return await axios.post(`/${endPoint}`, null, { params: {
      stripeToken: stripeToken,
    }})
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function generatePaymentMethod(payload) {
  axios.defaults.timeout = 10000;
  const { userType, stripeToken } = { ...payload }
  const endPoint = userType === 'business' ? 'business/payment_settings' : 'specialist/payment_settings/create_card'
  return await axios.post(`/${endPoint}`, null, { params: {
      stripeToken: stripeToken,
    }})
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function getPaymentMethod(payload) {
  const { userType } = {...payload}
  return await axios.get(`/${userType}/payment_settings`)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function deletePaymentMethod(payload) {
  const { userType, id } = {...payload}
  return await axios.delete(`/${userType}/payment_settings/${id}`)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

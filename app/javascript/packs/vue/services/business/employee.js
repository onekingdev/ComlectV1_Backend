import axios from '../../services/axios'
import store from '../../store/business'

const END_POINT = '/business/team_members'

export async function getEmployees() {
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

export async function createEmployee(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => {
      // if (response.status !== 200 || response.status !== 201) throw new Error(`${response.status} ${response.statusText}`)
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updateEmployee(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function deleteEmployee(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function getAvailableSeatsCount() {
  return axios
    .get(`/business/seats/available_seat_count`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}

export async function getEmployeesSpecialists() {
  return axios
    .get(`${END_POINT}/specialists`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => err)
}

import axios from '../../services/axios'
import store from '../../store/business'

const END_POINT = '/business/exams'

export async function getExams() {
  return axios
    .get(`${END_POINT}`)
    .then(response => {
      if (response) {
        return response
      }
      return response
    })
    .catch(err => console.error(err))
}

export async function createExam(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => console.error(err))
}

export async function getExam(payload) {
  return await axios.get(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => console.error(err))
}

export async function updateExam(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => console.error(err))
}

export async function deleteExam(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => console.error(err))
}
import axios from '../../services/axios'
import store from '../../store/business'

const END_POINT = '/business/exams'

export async function getExams() {
  return axios
    .get(`${END_POINT}`)
    .then(response => response)
    .catch(err => err)
}

export async function createExam(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => response)
    .catch(err => err)
}

export async function updateExam(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}`, payload)
    .then(response => response)
    .catch(err => err)
}

export async function deleteExam(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}`, payload)
    .then(response => response)
    .catch(err => err)
}

export async function getExamById(payload) {
  return await axios.get(`${END_POINT}/${payload}`)
    .then(response => response)
    .catch(err => err)
}

export async function createExamRequest(payload) {
  return await axios.post(`${END_POINT}/${payload.id}/requests`, payload.request)
    .then(response => response)
    .catch(err => err)
}

export async function updateExamRequest(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}/requests/${payload.request.id}`, payload.request)
    .then(response => response)
    .catch(err => err)
}

export async function deleteExamRequest(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}/requests/${payload.requestId}`)
    .then(response => response)
    .catch(err => err)
}

export async function uploadExamRequestFile(payload) {
  const config = {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  };
  return await axios.post(`${END_POINT}/${payload.id}/requests/${payload.request.id}/documents`, payload.formData, config)
    .then(response => response)
    .catch(err => err)
}

export async function deleteExamRequestFile(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}/requests/${payload.request.id}/documents/${payload.file.id}`)
    .then(response => response)
    .catch(err => err)
}

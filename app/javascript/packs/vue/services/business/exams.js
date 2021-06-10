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
    .catch(err => err)
}

export async function createExam(payload) {
  return await axios.post(`${END_POINT}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updateExam(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function deleteExam(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}`, payload)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function getExamById(payload) {
  return await axios.get(`${END_POINT}/${payload}`)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function createExamRequest(payload) {
  return await axios.post(`${END_POINT}/${payload.id}/requests`, payload.request)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function updateExamRequest(payload) {
  return await axios.patch(`${END_POINT}/${payload.id}/requests/${payload.request.id}`, payload.request)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function deleteExamRequest(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}/requests/${payload.requestId}`)
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function uploadExamRequestFile(payload) {
  const config = {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  };
  return await axios.post(`${END_POINT}/${payload.id}/requests/${payload.request.id}/documents`, payload.formData, config)
    .then(response => {
      if (response) {
        return response.data
      }
      return false
    })
    .catch(err => err)
}

export async function deleteExamRequestFile(payload) {
  return await axios.delete(`${END_POINT}/${payload.id}/requests/${payload.request.id}/documents/${payload.file.id}`)
    .then(response => {
      if (response) {
        return response.data
      }
      return false
    })
    .catch(err => err)
}

export async function sendInvite(payload) {
  return await axios.post(`${END_POINT}/${payload.id}/invite`, {email: payload.email})
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function sendUninvite(payload) {
  return await axios.post(`${END_POINT}/${payload.id}/uninvite`, {email: payload.email})
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function confirmEmail(payload) {
  return await axios.post(`/exams/${payload.uuid}`, {email: payload.email})
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

export async function confirmOTP(payload) {
  return await axios.PATCH(`/exams/${payload.uuid}`, {
    email: payload.email,
    otp: payload.otp,
  })
    .then(response => {
      if (response) {
        return response
      }
      return false
    })
    .catch(err => err)
}

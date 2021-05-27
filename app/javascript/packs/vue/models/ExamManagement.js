export default class ExamManagement {
  constructor(complete, created_at, ends_on, exam_requests, id, name, share_uuid, starts_on, updated_at) {
    this.complete = complete,
    this.created_at = created_at,
    this.ends_on = ends_on,
    this.exam_requests = this.examRequests(exam_requests),
    // this.exam_requests_attributes = [],
    this.id = id,
    this.name = name,
    this.share_uuid = share_uuid,
    this.starts_on = starts_on,
    this.updated_at = updated_at
  }

  examRequests(exam_requests) {
    return exam_requests.map(request => {
      return {
        complete: request.complete,
        details: request.details,
        exam_request_files: request.exam_request_files,
        id: request.id,
        name: request.name,
        shared: request.shared,
        text_items: request.text_items.map(text => ({ text })) || [],
      }
    })
  }
}


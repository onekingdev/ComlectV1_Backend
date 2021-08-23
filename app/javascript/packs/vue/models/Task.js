export class Task {
  constructor(body, created_at, description, done_at, done_occurencies, end_by, end_date, id, linkable_id, linkable_type, note, on_type, remind_at, remindable_id, remindable_type, repeat_every, repeat_on, repeats, skip_occurencies, updated_at) {
    this.body = body,
    this.created_at = created_at,
    this.description = description,
    this.done_at = done_at,
    this.done_occurencies = done_occurencies,
    this.end_by = end_by,
    this.end_date = end_date,
    this.id = id,
    this.linkable_id = linkable_id,
    this.linkable_type = linkable_type,
    this.note = note,
    this.on_type = on_type,
    this.remind_at = remind_at,
    this.remindable_id = remindable_id,
    this.remindable_type = remindable_type,
    this.repeat_every = repeat_every,
    this.repeat_on = repeat_on,
    this.repeats = repeats,
    this.skip_occurencies = skip_occurencies,
    this.updated_at = updated_at
  }
}

export class TaskOverdue extends Task {
  constructor(body, created_at, description, done_at, done_occurencies, end_by, end_date, id, linkable_id, linkable_type, note, on_type, remind_at, remindable_id, remindable_type, repeat_every, repeat_on, repeats, skip_occurencies, updated_at,
              course, icons, oid, start, taskId, title) {

    super(body, created_at, description, done_at, done_occurencies, end_by, end_date, id, linkable_id, linkable_type, note, on_type, remind_at, remindable_id, remindable_type, repeat_every, repeat_on, repeats, skip_occurencies, updated_at);
    this.icons = icons,
    this.oid = oid,
    this.start = start,
    this.taskId = taskId,
    this.title = title
  }
}

export class TaskMessage {
  constructor(created_at, file_data, id, message, recipient, sender) {
    this.created_at = created_at,
    this.file_data = fileDataUpdate(file_data),
    this.id = id,
    this.message = message,
    this.recipient = recipient,
    this.sender = sender
  }

  fileDataUpdate(file_data) {
    if(file_data)
      return {
        id: `/uploads/store/${file_data.id}`,
        metadata: file_data.metadata,
        storage: file_data.file,
      }
    return null
  }
}

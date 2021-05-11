export default class Policy {
  constructor(created_at, description, id, name, position, sections = null, src_id, status, updated_at) {
    this.created_at = created_at,
      this.description = description,
      this.id = id,
      this.name = name,
      this.position = position,
      this.sections = sections,
      this.srcId = src_id,
      this.status = status,
      this.updated_at = updated_at
  }
}


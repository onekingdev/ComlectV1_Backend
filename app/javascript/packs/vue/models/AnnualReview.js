export default class AnnualReview {
  constructor(annual_review_employees, business_id, created_at, exam_end, exam_start, id, material_business_changes, pdf_url, regulatory_changes, review_categories, review_end, review_start, updated_at, year, name) {
    this.annual_review_employees = annual_review_employees
    this.business_id = business_id
    this.created_at = created_at
    this.exam_end = exam_end
    this.exam_start = exam_start
    this.id = id
    this.material_business_changes = material_business_changes
    this.pdf_url = pdf_url
    if (regulatory_changes.length) {
      this.regulatory_changes = [
        { change: regulatory_changes[0]?.change },
        { change: regulatory_changes[1]?.change }
      ]
    } else {
      this.regulatory_changes = [
        { change: "" },
        { change: "" }
      ]
    }

    this.review_categories = review_categories
    this.review_end = review_end
    this.review_start = review_start
    this.updated_at = updated_at
    this.year = year
    this.name = name
    this.findings = this.findingsCalculate(review_categories)
    this.progress = review_categories.filter(item => item.complete).length
  }

  findingsCalculate(review_categories) {
    let findings = 0
    if (review_categories) {
      for (const reviewCategory of review_categories) {
        if (reviewCategory.review_topics) {
          for (const reviewTopic of reviewCategory.review_topics) {
            for (const reviewTopicItem of reviewTopic.items) {
              findings += reviewTopicItem.findings.length
            }
          }
        }
      }
    }
    return findings
  }
}


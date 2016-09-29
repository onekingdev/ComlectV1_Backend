# frozen_string_literal: true
class Payment::Export
  def self.to_csv(records)
    CSV.generate(headers: true) do |csv|
      csv << %w(date project business amount outstanding_balance)
      records.each do |record|
        csv << [
          record.process_after.strftime('%b %d, %Y'),
          record.project.to_s,
          record.project.business.to_s,
          record.amount,
          'TODO' # TODO
        ]
      end
    end
  end
end

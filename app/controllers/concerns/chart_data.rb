# frozen_string_literal: true

module ChartData
  def transactions_monthly(business_or_specialist)
    data = business_or_specialist
           .transactions
           .select("date_part('month', transactions.processed_at) as m, sum(transactions.amount_in_cents) as total")
           .where('transactions.processed_at >= ?', Time.now.utc.beginning_of_year)
           .group('m')
           .order('m').to_a
    kv = Hash.new(0)

    data.each { |s| kv[s.m.to_i] = BigDecimal(s.total) / 100 }

    (1..Time.zone.today.month).to_a.map { |i| kv[i] }
  end
end

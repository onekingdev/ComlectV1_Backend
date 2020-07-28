# frozen_string_literal: true

module ChartData
  def transactions_monthly
    data = current_user
           .business
           .transactions
           .select("date_part('month', transactions.processed_at) as m, sum(transactions.amount_in_cents) as total")
           .where('transactions.processed_at >= ?', Time.now.utc.beginning_of_year)
           .group('m')
           .order('m').to_a
    kv = Hash.new(0)

    data.each { |s| kv[s.m.to_i] = BigDecimal(s.total) / 100 }

    (1..12).to_a.map { |i| kv[i] }
  end
end

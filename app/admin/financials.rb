# frozen_string_literal: true

ActiveAdmin.register_page 'Financials' do
  page_action :download, method: :get do
    send_data ::Metrics::Financials.new.to_csv, filename: 'financials.csv'
  end

  action_item :download do
    link_to 'Download CSV', admin_financials_download_path(format: :csv)
  end

  content title: 'Financials' do
    def render_rows(rows, level = 0, cols: 3)
      rows.each do |name, values|
        tr class: cycle('odd', 'even') do
          td name, class: "col col-level-#{level}"
          values[0..cols - 1].each { |val| td val, class: 'col number' }
        end
        render_rows values[cols], level + 1, cols: cols if values[cols]
      end
    end

    financials = ::Metrics::Financials.new
    columns do
      column do
        panel 'Actual' do
          table do
            tr do
              th '', class: 'col'
              th 'MTD', class: 'col number'
              th 'FYTD', class: 'col number'
              th 'ITD', class: 'col number'
            end

            render_rows financials.actual
          end
        end
      end

      column do
        panel 'Postings' do
          table do
            tr do
              th '', class: 'col'
              th 'All Periods', class: 'col number'
            end

            render_rows ::Metrics::Financials::Postings.new.postings, cols: 1
          end
        end
      end
    end
  end
end

# frozen_string_literal: true
ActiveAdmin.register_page "Metrics" do
  content title: 'Metrics' do
    def render_rows(rows, level = 0)
      rows.each do |name, values|
        tr class: cycle('odd', 'even') do
          td name, class: "col col-level-#{level}"
          values[0..2].each { |val| td val, class: 'col number' }
        end
        render_rows values[3], level + 1 if values[3]
      end
    end

    metrics = ::Metrics.new
    columns do
      column do
        panel 'Postings' do
          table do
            tr do
              th '', class: 'col'
              th 'MTD', class: 'col number'
              th 'FYTD', class: 'col number'
              th 'ITD', class: 'col number'
            end

            render_rows metrics.postings
          end
        end

        panel 'Completions' do
          table do
            tr do
              th '', class: 'col'
              th 'MTD', class: 'col number'
              th 'FYTD', class: 'col number'
              th 'ITD', class: 'col number'
            end

            render_rows metrics.completions
          end
        end
      end

      column do
        panel 'Activity' do
        end
      end
    end
  end
end

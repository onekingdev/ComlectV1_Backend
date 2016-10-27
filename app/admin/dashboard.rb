# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: 'Dashboard' do
    columns do
      column do
        panel 'Money Managed' do
          h1 number_to_currency(Transaction.sum(:amount_in_cents) / 100.0)
        end
      end

      column do
        panel 'Businesses' do
          h1 Business.count
        end
      end

      column do
        panel 'Specialists' do
          h1 Specialist.count
        end
      end
    end
  end
end

# frozen_string_literal: true

unless AdminUser.any?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

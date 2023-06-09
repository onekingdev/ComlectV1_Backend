# frozen_string_literal: true

desc 'split TeamMember.name to first and last'
task team_members_names: :environment do
  TeamMember.where(first_name: nil, last_name: nil).all.each do |tm|
    next if tm.name.blank?

    names = tm.name.split(' ')
    puts names.inspect
    puts names.length
    next if names.length.zero?

    tm.first_name = names[0]
    tm.last_name = names[1] unless names[1].nil?
    tm.save
  end
  puts 'done!'
end

task add_business_user_as_employee: :environment do
  Business.all.each do |business|
    business&.add_as_employee
  end
end

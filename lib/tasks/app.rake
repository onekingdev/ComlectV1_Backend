# frozen_string_literal: true
namespace :app do
  task :rename, [:new_name] => :environment do |_t, args|
    if args[:new_name].blank?
      puts 'Usage: rake app:rename[NewName]'
    else
      files = %w(.env.development .env.test app/views/layouts/application.html.slim bower.json
                 config/application.rb config/initializers/session_store.rb)
      app_name = Rails.application.class.name.sub(/::Application$/, '')
      replacements = { app_name.underscore => args[:new_name].underscore,
                       app_name => args[:new_name].classify,
                       app_name.underscore.upcase => args[:new_name].underscore.upcase }
      files.each do |file|
        new_content = File.read(file).gsub(/#{replacements.keys.join('|')}/) do |match|
          replacements[match]
        end
        File.open(file, 'w') { |f| f.puts new_content }
      end
    end
  end
end

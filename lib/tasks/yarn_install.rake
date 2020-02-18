# frozen_string_literal: true

Rake::Task['yarn:install'].clear
namespace :yarn do
  task :install do
    # Redefine as empty
  end
end

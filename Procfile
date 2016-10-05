web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers -q payments -e production
release: bundle exec rake db:migrate

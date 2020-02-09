# frozen_string_literal: true

app_dir = '/var/www/complect/current'

working_directory app_dir

pid "#{app_dir}/tmp/pids/unicorn.pid"

stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

worker_processes 2
# listen 3000, :tcp_nopush => true
listen '/tmp/complect_staging.sock', backlog: 64
timeout 60

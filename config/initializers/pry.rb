# frozen_string_literal: true

# Show red environment name in pry prompt
# old_prompt = Pry.config.prompt
# release_stage = ENV['BUGSNAG_RELEASE_STAGE'] || Rails.env
# env = Pry::Helpers::Text.red(release_stage.upcase)
# Pry.config.prompt = [
#  proc { |*a| "#{env} #{old_prompt.first.call(*a)}" },
#  proc { |*a| "#{env} #{old_prompt.second.call(*a)}" }
# ]

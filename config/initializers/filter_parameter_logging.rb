# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i(password password_confirmation)
# To not strain logs with big base64 outputs
Rails.application.config.filter_parameters += %i(verification_document_data verification_document_cache)

Gibbon::Request.api_key = ENV.fetch("MAILCHIMP_API_KEY")
Gibbon::Request.timeout = 150
Gibbon::Request.open_timeout = 150
# Gibbon::Request.symbolize_keys = true
Gibbon::Request.debug = true

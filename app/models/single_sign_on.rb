# frozen_string_literal: true

class SingleSignOn
  ACCESSORS = %i[nonce name username email avatar_url avatar_force_update require_activation
                 bio external_id return_sso_url admin moderator suppress_welcome_message].freeze
  BOOLS = %i[avatar_force_update admin moderator require_activation suppress_welcome_message].freeze
  NONCE_EXPIRY_TIME = 10.minutes

  attr_accessor(*ACCESSORS)
  attr_accessor :sso_secret, :sso_url

  def self.sso_secret
    raise RuntimeError
  end

  def self.sso_url
    raise RuntimeError
  end

  def self.parse(payload, sso_secret = nil)
    sso = new
    sso.sso_secret = sso_secret if sso_secret

    parsed = Rack::Utils.parse_query(payload)
    raise Runtime Error if sso.sign(parsed['sso']) != parsed['sig']

    decoded = Base64.decode64(parsed['sso'])
    decoded_hash = Rack::Utils.parse_query(decoded)

    sso = modified_sso_on_accessors(sso, decoded_hash)
    sso = modified_sso_on_custom(sso, decoded_hash)
    sso
  end

  def self.modified_sso_on_accessors(sso, decoded_hash)
    ACCESSORS.each do |k|
      val = decoded_hash[k.to_s]
      if BOOLS.include? k
        val = %w[true false].include?(val) ? val == 'true' : nil
      end
      sso.__send__("#{k}=", val)
    end
    sso
  end

  def self.modified_sso_on_custom(sso, decoded_hash)
    decoded_hash.each do |k, v|
      if k[0..6] == 'custom.'
        field = k[7..-1]
        sso.custom_fields[field] = v
      end
    end
    sso
  end

  def diagnostics
    SingleSignOn::ACCESSORS.map do |a|
      "#{a}: #{__send__(a)}"
    end.join("\n")
  end

  # something strange here
  # we have these methods as `attr_accessor`
  # rubocop:disable Lint/DuplicateMethods
  def sso_secret
    @sso_secret || self.class.sso_secret
  end

  def sso_url
    @sso_url || self.class.sso_url
  end
  # rubocop:enable Lint/DuplicateMethods

  def custom_fields
    @custom_fields ||= {}
  end

  def sign(payload)
    OpenSSL::HMAC.hexdigest('sha256', sso_secret, payload)
  end

  def to_url(base_url = nil)
    base = base_url || sso_url
    "#{base}#{base.include?('?') ? '&' : '?'}#{payload}"
  end

  def payload
    payload = Base64.encode64(unsigned_payload)
    "sso=#{CGI.escape(payload)}&sig=#{sign(payload)}"
  end

  def unsigned_payload
    payload = {}
    ACCESSORS.each do |k|
      next if (val = __send__ k).nil?

      payload[k] = val
    end

    @custom_fields&.each do |k, v|
      payload["custom.#{k}"] = v.to_s
    end

    Rack::Utils.build_query(payload)
  end
end

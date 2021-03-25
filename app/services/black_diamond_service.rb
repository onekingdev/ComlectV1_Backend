# frozen_string_literal: true

class BlackDiamondService
  attr_accessor :token_access, :token_refresh, :con, :client_id, :client_secret
  attr_reader :username, :password

  def initialize(options = Hash.new(nil))
    @client_id = options[:client_id]
    @client_secret = options[:secret]
    @username = options[:username]
    @password = options[:password]
    @token_access = options[:access_token]
    @token_refresh = options[:refresh_token]

    if @username && @password
      authenticate
    elsif @token_access && @token_refresh
      refresh_token
    end

    init_faraday
  end

  def req_get(url, attrs = {})
    res = @con.get(url, attrs)

    if res.status == 401 && json_response(res)[:message].match?(/token.*expired/)
      refresh_token
      init_faraday
      req_get(url, attrs)
    end
    json_response(res)
  end

  def authenticate
    resp = Faraday.post(
      auth_url,
      auth_options.merge(
        username: @username,
        password: @password
      ),
      form_headers
    )

    raise json_response(resp)[:error] unless resp.status == 200

    @token_access = json_response(resp)[:access_token]
    @token_refresh = json_response(resp)[:refresh_token]
  end

  def refresh_token
    resp = Faraday.post(
      auth_url,
      auth_options.merge(
        grant_type: 'refresh_token',
        refresh_token: @token_refresh
      ),
      form_headers
    )

    raise json_response(resp)[:error] unless resp.status == 200

    @token_access = json_response(resp)[:access_token]
    @token_refresh = json_response(resp)[:refresh_token]
  end

  def auth_url
    'https://apisandbox.bdreporting.com/issue/oauth2/token'
  end

  def json_response(resp)
    JSON.parse(resp.body, symbolize_names: true)
  end

  def auth_headers
    {
      'Authorization': "Bearer #{@token_access}"
    }
  end

  def form_headers
    {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  end

  def init_faraday
    @con = Faraday.new('https://apisandbox.bdreporting.com', headers: auth_headers)
  end

  def auth_options
    {
      grant_type: 'password',
      client_id: @client_id,
      client_secret: @client_secret
    }
  end
end

# when first time
# attrs = {
#   client_id: "Complect_Sandbox_Api",
#   secret: "123",
#   username: "complect_apiuser",
#   password: "123"
# }
#
# when already have token and refresh_token
# attrs = {
#   client_id: "Complect_Sandbox_Api",
#   secret: "123",
#   access_token: "123456",
#   refresh_token: "123"
# }
#
# bd = BlackDiamondService.new(attrs)
#
# bd.req_get('/v1/client') =>
# {
#   :message=> "Please provide your advisor or administrator with this code to help troubleshoot the issue.",
#   :code=> 500,
#   :correlationID=> "12119a69-2e7d-48ad-a302-260faa59f907"
# }
# bd.req_get('/v1/account') =>
#
# {
#   :id=>"5728411",
#   :name=>"- Trust",
#   :accountNumber=>"506419429",
#   :accountLongNumber=>"506419429",
#   :custodianName=>"Fidelity IWS",
#   :styleName=>"Balanced",
#   :managerName=>"Lord Abbott",
#   :taxMethodology=>"HighestCost"
# }

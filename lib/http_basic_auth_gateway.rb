require "net/http"

class Net::HTTP::BasicAuthGateway
  attr_accessor :uri, :form_data, :user_name, :password, :request_type, :skip_ssl
  def initialize(data)
    @form_data    = data[:form_data]
    @password     = data[:password]
    @skip_ssl     = data[:skip_ssl] || false
    @user_name    = data[:user_name]
    set_uri(data[:url])
    set_verb(data[:verb])
  end

  def send
    begin
      response = get_response
      return {result: "success", response: response, message: response.body}
    rescue Exception => error
      return {result: "failure", error: error}
    end
  end

  def set_uri(url)
    @uri = URI.parse(url)
  end

  def set_verb(verb)
    case verb
    when :put
      @request_type = Net::HTTP::Put
    when :post
      @request_type = Net::HTTP::Post
    when :get
      @request_type = Net::HTTP::Get
    when :delete
      @request_type = Net::HTTP::Delete
    else
      raise "HTTP Verb not supplied."
    end
  end

  private
  def get_response
    Net::HTTP.start(uri.host, uri.port, http_options) do |http|
      request = request_type.new(uri.request_uri)
      request.content_type = 'application/json'
      request.basic_auth user_name, password
      request.set_form_data(form_data) if form_data
      http.request(request)
    end
  end

  def http_options
    if skip_ssl
      nil
    else
      options = {use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE}
    end
  end
end

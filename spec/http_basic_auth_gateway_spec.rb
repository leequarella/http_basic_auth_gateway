require "http_basic_auth_gateway"
require 'webmock/rspec'

describe Net::HTTP::BasicAuthGateway do
  let(:url){'http://testing.com/testing'}
  let(:user_name){"apiUser"}
  let(:password){"welcome"}
  let(:form_data) do
    {provider: {
      response_code: 2,
      response_note: '3'}}
  end

  let(:gateway) do
    Net::HTTP::BasicAuthGateway.new({
      verb:      :put,
      skip_ssl:  true,
      form_data: form_data,
      url:       url,
      user_name: user_name,
      password:  password})
  end

  it "initiallizes" do
    expect(gateway.form_data).to eq form_data
    expect(gateway.user_name).to eq user_name
    expect(gateway.password).to eq password
    expect(gateway.uri).to eq URI.parse(url)
  end

  describe "failure" do
    it "gives the correct response" do
     stub_request(:put, "http://apiUser:welcome@testing.com/testing")
       .to_raise(StandardError)
      result_message = gateway.send
      expect(result_message[:result]).to eq "failure"
      expect(result_message[:error]).to be_an_instance_of StandardError
    end
  end

  describe "successful requests without ssl" do
    it "handles POST requests" do
      stub_request(:post, "http://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      gateway.set_verb(:post)
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
    it "handles GET requests" do
      stub_request(:get, "http://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      gateway.set_verb(:get)
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
    it "handles PUT requests" do
      stub_request(:put, "http://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
    it "handles DELETE requests" do
      stub_request(:delete, "http://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      gateway.set_verb(:delete)
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
  end

  describe "successful requests with ssl" do
    before :each do
      gateway.set_uri("https://testing.com/testing")
      gateway.skip_ssl = false
    end
    it "handles POST requests" do
      stub_request(:post, "https://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      gateway.set_verb(:post)
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
    it "handles GET requests" do
      stub_request(:get, "https://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      gateway.set_verb(:get)
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
    it "handles PUT requests" do
      stub_request(:put, "https://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
    it "handles DELETE requests" do
      stub_request(:delete, "https://apiUser:welcome@testing.com/testing")
        .to_return(:status => 200, :body => "some_message", :headers => {})
      gateway.set_verb(:delete)
      result_message = gateway.send
      expect(result_message[:result]).to eq "success"
      expect(result_message[:response].code).to eq "200"
      expect(result_message[:message]).to eq "some_message"
    end
  end
end

Simple wrapper for REST http transactions with basic auth

## Setup

Add it to your Gemfile then run `bundle` to install it.

```ruby
gem "http_basic_auth_gateway"
```


## Usage
###Create the gateway
```ruby
gateway = Net::HTTP::BasicAuthGateway.new({
  verb:      :put,
  skip_ssl:  true,
  form_data: form_data,
  url:       url,
  user_name: user_name,
  password:  password})
```

###Send it off on it's merry way
```ruby
result_message = gateway.send
```


###Get a response
If the transaction was sucessful and the card was approved, the response will have the following attrs:
```ruby
 result_message #=> {result: "success",
                     response: <full response object>,
                     message: <response body of the transaction>}
```


Otherwise there was some problem with the transaction, so the response will have these attrs:
```ruby
 result_message #=> {result: "failure",
                     error: <exception object>}
```
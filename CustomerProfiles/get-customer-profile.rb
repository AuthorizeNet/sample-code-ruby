require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = GetCustomerProfileRequest.new
  request.customerProfileId = '37115969'

  response = transaction.get_customer_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully retrieved a customer with profile id is #{request.customerProfileId} and whose customer id is #{response.profile.merchantCustomerId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to get customer profile information with id #{request.customerProfileId}"
  end

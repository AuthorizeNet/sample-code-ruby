require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = CreateCustomerProfileRequest.new
  request.profile = CustomerProfileType.new('jdoe','John Doe','jdoe@mail.com',nil, nil)

  response = transaction.create_customer_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a customer profile with id:  #{response.customerProfileId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to create a customer profile from an existing transaction."
  end

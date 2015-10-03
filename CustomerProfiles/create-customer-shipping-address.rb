require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = CreateCustomerShippingAddressRequest.new
  
  request.address = CustomerAddressType.new('John','Doe')
  request.customerProfileId = '35894174'
  response = transaction.create_customer_shipping_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a customer shipping address with id:  #{response.customerAddressId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to create a new customer shipping address."
  end
require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = DeleteCustomerProfileRequest.new
  request.customerProfileId = '36551110'

  response = transaction.delete_customer_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully deleted customer with customer profile id #{request.customerProfileId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to delete customer with customer profile id #{request.customerProfileId}"
  end


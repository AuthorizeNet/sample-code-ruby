require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = CreateCustomerProfileFromTransactionRequest.new
  request.transId = 2238251168
  response = transaction.create_customer_profile_from_transaction(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a customer profile from the transaction id #{request.customerProfileId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to create a customer profile from an existing transaction."
  end

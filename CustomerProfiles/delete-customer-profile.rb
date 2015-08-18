require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = DeleteCustomerProfileRequest.new
  request.profile = CustomerProfileExType.new

  #Edit this part to select a specific customer
  request.profile.customerProfileId = "35704713"
  
  
  response = transaction.delete_customer_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully updated customer with customer profile id #{request.profile.customerProfileId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to failed to update customer with customer profile id #{request.profile.customerProfileId}"
  end


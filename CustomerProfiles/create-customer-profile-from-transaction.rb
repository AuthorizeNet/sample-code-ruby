require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def create_customer_profile_from_a_transaction(transId = 2242762682)
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = CreateCustomerProfileFromTransactionRequest.new
    request.transId = transId
	
	#You can either specify the customer information in form of customerProfileBaseType object
	request.customer = CustomerProfileBaseType.new
	request.customer.merchantCustomerId = "1231232"
    request.customer.description = "This is a sample customer profile"
    request.customer.email = "johnsnow@castleblack.com"
	#  OR   
	# You can just provide the customer Profile ID
	# customerProfileId = "123343" 
	
    response = transaction.create_customer_profile_from_transaction(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully created a customer profile from the transaction id #{response.customerProfileId}"
    else
      puts response.messages.messages[0].text
      raise "Failed to create a customer profile from an existing transaction."
    end
    return response
  end

if __FILE__ == $0
  create_customer_profile_from_a_transaction()
end
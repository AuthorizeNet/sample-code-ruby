require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

include AuthorizeNet::API

def validate_customer_payment_profile(customerProfileId = '36152115', customerPaymentProfileId = '32689262')
	config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

	transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

	request = ValidateCustomerPaymentProfileRequest.new

	#Edit this part to select a specific customer
	request.customerProfileId = customerProfileId
	request.customerPaymentProfileId = customerPaymentProfileId
	request.validationMode = ValidationModeEnum::TestMode

	response = transaction.validate_customer_payment_profile(request)

	if response.messages.resultCode == MessageTypeEnum::Ok
	  puts "Successfully validated customer with customer profile ID #{request.customerProfileId}"
	  puts "Direct Response: #{response.directResponse} "
	else
	    puts response.messages.messages[0].code
	    puts response.messages.messages[0].text
	    raise "Failed to validate customer with customer profile ID #{request.customerProfileId} and payment profile ID #{customerPaymentProfileId}"
	end

	return response

end

if __FILE__ == $0
  validate_customer_payment_profile()
end
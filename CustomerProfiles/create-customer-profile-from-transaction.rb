require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def create_customer_profile_from_a_transaction(transId = 60031516226)
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = CreateCustomerProfileFromTransactionRequest.new
    request.transId = transId
	
    # You can either specify the customer information to create a new customer profile
    # or, specify an existing customer profile ID to create a new customer payment profile
    # attached to the existing customer profile. If no profile information is specified,
    # a new profile will still be created as long as either an ID or email exists in the
    # original transaction that can be used to identify a new profile.
    #
    # To create a new customer profile containing a payment profile with this transaction's
    # payment information, submit the new profile information in the form of a
    # customerProfileBaseType object
    request.customer = CustomerProfileBaseType.new
    request.customer.merchantCustomerId = "1231232"
    request.customer.description = "This is a sample customer profile"
    request.customer.email = "johnsnow@castleblack.com"
    # -OR- to create a payment profile under an existing customer profile,
    # just provide the customer Profile ID
    # customerProfileId = "123343" 
	
    response = transaction.create_customer_profile_from_transaction(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully created a customer profile from transaction ID #{transId}"
      puts "Customer profile ID: #{response.customerProfileId}"
      puts "New customer payment profile ID: #{response.customerPaymentProfileIdList.numericString[0]}"
      puts "New customer shipping profile ID (if created): #{response.customerShippingAddressIdList.numericString[0]}"
    else
      puts response.messages.messages[0].text
      raise "Failed to create a customer profile from an existing transaction."
    end
    return response
  end

if __FILE__ == $0
  create_customer_profile_from_a_transaction()
end
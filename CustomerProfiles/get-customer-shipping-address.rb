 require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def get_customer_shipping_address(customerProfileId = '35894174', customerAddressId = '35745790')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerShippingAddressRequest.new
    request.customerProfileId = customerProfileId
    request.customerAddressId = customerAddressId

    response = transaction.get_customer_shipping_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully retrieved a shipping address with profile id #{request.customerAddressId} and whose customer id is #{request.customerProfileId}"
    else
      puts response.messages.messages[0].text
      raise "Failed to get payment profile information with id #{request.customerPaymentProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
  get_customer_shipping_address()
end


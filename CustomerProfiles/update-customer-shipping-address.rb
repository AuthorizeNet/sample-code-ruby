require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def update_customer_shipping_address(customerProfileId = '35894174', customerAddressId = '35745790')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = UpdateCustomerShippingAddressRequest.new

    
    request.address = CustomerAddressExType.new('John','Doe','Anet','800 N 106th')
    
    #Edit this part to select a specific customer
    request.address.customerAddressId = customerAddressId
    request.customerProfileId = customerProfileId

    response = transaction.update_customer_shipping_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully updated customer with customer profile ID #{request.address.customerAddressId}."
    else
      puts response.messages.messages[0].text
      raise "Failed to update customer with customer profile ID #{request.address.customerAddressId}."
    end
    return response
  end
  
if __FILE__ == $0
  update_customer_shipping_address()
end

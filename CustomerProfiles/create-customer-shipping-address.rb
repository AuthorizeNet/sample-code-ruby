require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  def create_customer_shipping_address(customerProfileId = '35894174')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = CreateCustomerShippingAddressRequest.new
    
    request.address = CustomerAddressType.new('John','Doe')
    request.customerProfileId = customerProfileId
    response = transaction.create_customer_shipping_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully created a customer shipping address with id:  #{response.customerAddressId}"
    else
      puts response.messages.messages[0].text
      raise "Failed to create a new customer shipping address."
    end
    return response
  end

if __FILE__ == $0
  create_customer_shipping_address()
end

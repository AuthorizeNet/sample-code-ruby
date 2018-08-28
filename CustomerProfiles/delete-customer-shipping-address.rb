require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def delete_customer_shipping_address(customerProfileId = '36551110', customerAddressId = '35894174')
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = DeleteCustomerShippingAddressRequest.new
    request.customerProfileId = customerProfileId
    request.customerAddressId = customerAddressId

    response = transaction.delete_customer_shipping_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully deleted shipping address with customer shipping profile ID #{request.customerAddressId}."
    else
      logger.error response.messages.messages[0].text
      raise "Failed to delete payment profile with profile ID #{request.customerAddressId}."
    end
    return response
  end

if __FILE__ == $0
  delete_customer_shipping_address()
end


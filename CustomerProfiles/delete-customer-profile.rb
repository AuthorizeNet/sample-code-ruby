require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def delete_customer_profile(customerProfileId = '36551110')
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = DeleteCustomerProfileRequest.new
    request.customerProfileId = customerProfileId

    response = transaction.delete_customer_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully deleted customer with customer profile ID #{request.customerProfileId}."
    else
      logger.error response.messages.messages[0].text
      raise "Failed to delete customer with customer profile ID #{request.customerProfileId}."
    end
    return response
  end

if __FILE__ == $0
  delete_customer_profile()
end
